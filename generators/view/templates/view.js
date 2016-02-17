import _Base from '<%= baseClassPath %>';
import template from './<%= componentName %>.jade';
import './<%= componentName %>.css';

export default _Base.extend({
  template,
  className: '<%= cssClassname %>',
});
