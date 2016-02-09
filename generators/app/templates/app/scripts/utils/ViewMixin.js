function constructor(SuperClass) {
  return SuperClass.extend({
    constructor() {
      const render = this.render;
      this.render = function () {
        const result = Reflect.apply(render, this, arguments);
        common.sblocks.init(this.$el);
        this.$el.addClass('view-mixin');
        return result;
      };

      const remove = this.remove;
      this.remove = function () {
        const result = Reflect.apply(remove, this, arguments);
        common.sblocks.destroy(this.$el);
        return result;
      };

      return Reflect.apply(SuperClass.prototype.constructor, this, arguments);
    },
  });
}

export default constructor;
