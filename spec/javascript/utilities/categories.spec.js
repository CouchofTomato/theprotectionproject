import productModuleCategories from "utilities/categories";

describe("productModuleCategories", () => {
  it("returns a list of the available categories for product modules", () => {
    expect(productModuleCategories).toEqual([
      "core",
      "outpatient",
      "medicines_and_appliances",
      "wellness",
      "maternity",
      "dental_and_optical",
      "evacuation_and_repatriation",
    ]);
  });
});
