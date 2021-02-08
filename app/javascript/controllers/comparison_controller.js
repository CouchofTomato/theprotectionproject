import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  connect() {
    super.connect();
  }

  static targets = [
    "insurer",
    "product",
    "productModule",
    "selectedProduct",
    "option",
  ];

  loadProducts() {
    const params = new URLSearchParams(window.location.search);
    const customerType = params.get("customer_type");
    this.stimulate(
      "Comparison#products",
      this.insurerTarget.value,
      customerType
    );
  }

  loadCoreProductModules() {
    this.stimulate("Comparison#core_modules", this.productTarget.value);
  }

  loadElectiveProductModules(event) {
    if (event.target.dataset.category !== "core") return;

    const productModuleId = event.target.value;
    this.stimulate(
      "Comparison#elective_modules",
      productModuleId,
      this.productTarget.value
    );
  }

  loadProductModules() {
    this.stimulate("Comparison#product_modules", this.productTarget.value);
  }

  addSelectedProduct(event) {
    event.preventDefault();
    this.stimulate(
      "Comparison#selected_products",
      this.selectedProducts(),
      this.exportOptions()
    );
  }

  setOptions() {
    this.stimulate(
      "Comparison#set_options",
      this.existingSelection(),
      this.exportOptions()
    );
  }

  selectedProducts() {
    const selection = this.existingSelection();
    selection.push(this.currentSelection());
    return selection;
  }

  existingSelection() {
    return this.selectedProductTargets.map((product) =>
      JSON.parse(product.dataset.productDetails)
    );
  }

  currentSelection() {
    return {
      insurer: this.insurerTarget.value,
      product: this.productTarget.value,
      product_modules: this.selectedModules(),
    };
  }

  selectedModules() {
    const selectedModules = this.productModuleTargets.filter(
      (radioButton) => radioButton.checked === true
    );

    return selectedModules.map((module) => module.value);
  }

  exportOptions() {
    return this.optionTargets
      .filter((option) => option.checked)
      .map((option) => option.value);
  }
}
