import ServerClient from 'sp-utils-serverclient';

export default class ServerAPI extends ServerClient {
  initialize() {}

  _isServer() {
    // can use stubs
    return false;
  }

  getData() {
    return this.get({
      url: '/api',
      stub: async => {
        async.resolve('stub data');
      },
    });
  }
}
