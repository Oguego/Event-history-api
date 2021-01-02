class EventSerializer < ActiveModel::Serializer
  attributes \
    :object_id,
    :object_type,
    :history

  def history
    histories = []
    object.histories.each do |history|
      data_before = history.data_before.empty? ? nil : history.data_before
      histories << { user: history.user, when: history.when, event: history.event_type,
                     dataBefore: data_before, dataAfter: history.data_after }
    end
    histories
  end
end
