module V1
  class Events < Grape::API
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    helpers do
      def create_event
        event = Event.find_by(object_id: params[:objectId], object_type: params[:objectType])

        if event
          error!('Event already exists', 403)
        end

        begin
          Event.transaction do
            event = Event.new
            event.object_id = params[:objectId]
            event.object_type = params[:objectType]
            event.save

            setup_history(event)
          end
        rescue => e
          errors = e.record.errors.full_messages.join(', ')
          render_error(422, errors.to_json)
        end
      end

      def render_error(code, message, debug_info = '')
        error!({ meta: { code: code, message: message, debug_info: debug_info } }, code)
      end

      def setup_history(event)
        history = History.new
        history.event_type = params[:event]
        history.when = params[:when]
        history.user = params[:user]
        history.data_before = get_data_before
        history.data_after = format_payload
        history.event = event
        history.save!
      end

      def format_payload
        name = params[:payload][:name]
        if name == 'null'
          name = nil
        end

        description = params[:payload][:description]

        if description == 'null'
          description = nil
        end

        {
          name: name,
          description: description
        }
      end

      def create_history
        event = Event.find_by(object_id: params[:objectId], object_type: params[:objectType])

        unless event
          error!('Cannot find event', 404)
        end

        setup_history(event)
      end

      def get_data_before
        if params[:event] == 'create'
          nil
        else
          event = Event.find_by(object_id: params[:objectId], object_type: params[:objectType])

          unless event
            error!('Cannot find event', 404)
          end

          event.histories.try(:last).try(:data_after)
        end
      end

      def handle_event
        puts case params[:event].downcase
             when 'create'
               create_event
             when 'update'
               create_history
             when 'delete'
               create_history
             else
               error!('Invalid event type', 404)
             end
      end
    end

    resource :events do
      desc 'post event',
           consumes: ['application/x-www-form-urlencoded'],
           http_codes: [
             { code: 200, message: 'success' },
           ]
      params do
        requires :event, type: String, desc: 'Event type'
        requires :when, type: String, desc: 'Date'
        requires :user, type: String, desc: 'user'
        requires :objectType, type: String, desc: 'Object Type'
        requires :objectId, type: Integer, desc: 'Object Id'
        optional :payload, type: Hash do
          optional :name, type: String
          optional :description, type: String
        end
      end
      post do
        handle_event
        { data: {}, meta: { code: 200, message: 'success' } }
      end

      desc 'Get an event.'
      params do
        requires :object_id, type: String, desc: 'Object ID.'
        requires :object_type, type: String, desc: 'Object Type.'
      end
      get ':object_type/:object_id', each_serializer: EventSerializer do
        Event.find_by(object_id: params[:object_id], object_type: params[:object_type])
      end
    end

  end
end