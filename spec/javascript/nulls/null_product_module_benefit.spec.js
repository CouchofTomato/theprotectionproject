import NullProductModuleBenefit from 'nulls/null_product_module_benefit'

describe('NullProductModuleBenefit', () => {
  describe('benefit_icon', () => {
    it('returns the HTML for a cross icon', () => {
      let nullProductModule = new NullProductModuleBenefit()
      expect(nullProductModule.benefit_icon).toEqual("<span class='icon'><i class='fa fa-times icon--not-covered'></i></span>")
    })
  })
})
