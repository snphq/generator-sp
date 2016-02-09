/* eslint no-unused-expressions: 0 */
describe('example test', () => {
  it('dont breaks math', () => {
    expect(2).to.be.eql(4 / 2);
  });

  it('dont breaks logic', () => {
    expect(1).to.be.ok;
  });
});
