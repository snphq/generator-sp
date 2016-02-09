/* eslint no-unused-expressions: 0 */
describe('<%= name %>', () => {
  it('dont breaks math', () => {
    expect(2).to.be.eql(4 / 2);
  });
});
