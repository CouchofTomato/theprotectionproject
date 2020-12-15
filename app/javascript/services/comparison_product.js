class ComparisonProduct {
  constructor(insurer, product, productModules, moduleBenefits) {
    this.insurer = insurer;
    this.product = product;
    this.productModules = productModules;
    this.moduleBenefits = moduleBenefits;
    this.benefitIcons = {
      paid_in_full:
        "<span class='icon'><i class='fa fa-check icon--full-cover'></i></span>",
      capped_benefit:
        "<span class='icon'><i class='fa fa-circle-notch icon--capped-cover'></i></span>",
    };
  }

  insurerName() {
    return this.insurer.name;
  }

  productName() {
    return this.product.name;
  }

  chosenCovers() {
    return this.productModules
      .map((productModule) => productModule.name)
      .join(" + ");
  }

  overallSumAssured() {
    return this.productModules.find(
      (productModule) => productModule.category === "core"
    ).sum_assured;
  }

  productModuleBenefit(id) {
    const productModuleBenefit = this.moduleBenefits.find(
      (productModule) => productModule.benefit.id === Number(id)
    );
    if (!productModuleBenefit) return undefined;
    productModuleBenefit.benefit_icon = this.benefitIcon(
      productModuleBenefit.benefit_status
    );
    return productModuleBenefit;
  }

  benefitIcon(benefitStatus) {
    return this.benefitIcons[benefitStatus];
  }
}

export default ComparisonProduct;
