import Backbone from 'backbone';
import PeopleModel from 'model/PeopleModel';

const PeopleCollection = Backbone.Collection.extend({
  model: PeopleModel,
});

export default PeopleCollection;
