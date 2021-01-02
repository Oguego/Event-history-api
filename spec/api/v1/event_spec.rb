require 'rails_helper'

describe V1::Events do
  describe 'POST /events' do
    let(:params) do
      {
        "objectType": "Task",
        "objectId": 0,
        "when": "2020-12-18T13:21:11.058Z",
        "user": "Hoyt Tillman",
        "event": "create",
        "payload": { "name": "Task 0", "status": "Initial stage" }
      }
    end
    let(:action) { post "/events", params: params }
    context 'Creates an event' do
      it 'is :ok' do
        action

        expect(response).to have_http_status(:created)
      end
    end

    context 'when there is an invalid data' do
      let(:params) do
        {
          "objectId": 0,
          "when": "2020-12-18T13:21:11.058Z",
          "user": "Hoyt Tillman",
          "event": "create",
          "payload": { "name": "Task 0", "status": "Initial stage" }
        }
      end
      it 'is bad request' do
        action

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /events' do
    let(:params) do
      {
        "objectType": "Task",
        "objectId": 0,
        "when": "2020-12-18T13:21:11.058Z",
        "user": "Hoyt Tillman",
        "event": "create",
        "payload": { "name": "Task 0", "status": "Initial stage" }
      }
    end
    let(:action) { post "/events", params: params }
    let(:fetch) { get "/events/Task/10", params: params }
    context 'Creates an event' do
      it 'is :ok' do
        action

        expect(response).to have_http_status(:created)
      end
    end

    context 'get an event' do
      it 'expects event objejct' do
        fetch

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
