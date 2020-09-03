class ComparisonProduct {
  constructor(insurer, product, productModules) {
    this._insurer = insurer
    this._product = product
    this._productModules = productModules
    this._productModuleBenefits = this.productModuleBenefits()
    this._benefitIcons = {
      "paid in full": "<span class='icon'><i class='fa fa-check green-check'></i></span>",
      "capped benefit": "<span class='icon'><i class='fa fa-circle-notch orange-circle-notch'></i></span>",
    }
  }

  insurerName() {
    return this._insurer.name
  }

  productName() {
    return this._product.name
  }

  chosenCovers() {
    return this._productModules
      .map(productModule => productModule.name)
      .join(" + ")
  }

  overallSumAssured() {
    return this._productModules
      .find(productModule => productModule.category == "core")
      .sum_assured
  }

  productModuleBenefit(id) {
    const productModuleBenefit = this._productModuleBenefits.find(productModule => productModule.benefit.id == id)
    if(!productModuleBenefit) return undefined
    productModuleBenefit.benefit_icon = this.benefitIcon(productModuleBenefit.benefit_status)
    return productModuleBenefit
  }

  productModuleBenefits() {
    const moduleBenefits = this._productModules.map(productModule => productModule.product_module_benefits)
    return [].concat.apply([], moduleBenefits)
  }

  benefitIcon(benefit_status) {
    return this._benefitIcons[benefit_status]
  }
}

export default ComparisonProduct
