import ComparisonProduct from 'services/comparison_product'

const data = {
  "insurer": {
    "name": "BUPA Global"
  },
  "product": {
    "name": "Lifeline"
  },
  "product_modules": [
    {
      "name": "Silver",
      "category": "core",
      "sum_assured": "USD 500,000 | GBP 300,000 | EUR 400,000"
    }
  ],
  "module_benefits": [
    {
      "benefit_status": "paid_in_full",
      "benefit_limit": "Within overall limit",
      "explanation_of_benefit": "a test explanation",
      "benefit": {
        "id": 2,
        "name": "Accomodation",
        "category": "inpatient"
      }
    }
  ]
}

describe('ComparisonProduct', () => {
  let product = new ComparisonProduct(data['insurer'], data['product'], data['product_modules'], data['module_benefits'])
  describe('insurerName', () => {
    it('returns the insurers name', () => {
      expect(product.insurerName()).toEqual('BUPA Global')
    })
  }),

  describe('productName', () => {
    it('returns the products name', () => {
      expect(product.productName()).toEqual('Lifeline')
    })
  }),

  describe('chosenCovers', () => {
    it('returns the names of the product modules joined with a +', () => {
      expect(product.chosenCovers()).toEqual('Silver')
    })
  }),

  describe('overallSumAssured', () => {
    it('returns the sum assured of the core module selected', () => {
      expect(product.overallSumAssured()).toEqual('USD 500,000 | GBP 300,000 | EUR 400,000')
    })
  }),

  describe('productModuleBenefit', () => {
    it('returns the product module benefit for the provided id', () => {
      expect(product.productModuleBenefit(2)).toMatchObject({
        "benefit_status": "paid_in_full",
        "benefit_limit": "Within overall limit",
        "explanation_of_benefit": "a test explanation",
        "benefit": {
          "id": 2,
          "name": "Accomodation",
          "category": "inpatient"
        }
      })
    }),

    it('adds the benefit icon html as a property', () => {
      expect(product.productModuleBenefit(2)).toHaveProperty('benefit_icon', "<span class='icon'><i class='fa fa-check icon--full-cover'></i></span>")
    })
  })
})
