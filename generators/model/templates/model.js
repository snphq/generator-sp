import Backbone from 'backbone';
import 'backbone.epoxy';

const <%= normalize_name %> = Backbone.Epoxy.Model.extend({
  defaults: {
    title: 'NoNaMe',
  },

  // parse(r) {
  //   return r;
  // },
});

export default <%= normalize_name %>;
