import _Base from '<%= baseClassPath %>';
import template from './<%= componentName %>.jade';
import './<%= componentName %>.sass';

export default _Base.extend({
  template,
  className: '<%= cssClassname %>',
});
