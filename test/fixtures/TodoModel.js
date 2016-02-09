import Backbone from 'backbone';
import 'backbone.epoxy';

const TodoModel = Backbone.Epoxy.Model.extend({
  defaults: {
    title: 'NoNaMe',
  },

  // parse(r) {
  //   return r;
  // },
});

export default TodoModel;
