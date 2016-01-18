import Backbone from 'backbone';
import <%= model_name %> from 'model/<%= model_name %>';

const <%= normalize_name %> = Backbone.Collection.extend({
  model: <%= model_name %>,
});

export default <%= normalize_name %>;
