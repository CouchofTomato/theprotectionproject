import titleize from "utilities/string_helpers";

describe("titleize", () => {
  it("Capitalises the first letter of a word", () => {
    expect(titleize("string")).toBe("String");
  });

  it("makes all letters except the first one lowercase", () => {
    expect(titleize("sTring")).toBe("String");
  });

  it("separates words joined with an underscore with a space and capitalizes all words", () => {
    expect(titleize("a_string")).toBe("A String");
  });
});
