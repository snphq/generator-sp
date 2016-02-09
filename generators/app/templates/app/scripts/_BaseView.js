import Backbone from 'backbone';
import mixinBackbone from 'backbone-mixin';

require('epoxy');

const SuperClass = mixinBackbone(Backbone.Epoxy.View);

export default SuperClass.extend({
  templateFunc() {
    return this.template || this.$el.html() || '';
  },
});
