function titleize(phrase) {
  return phrase
    .split("_")
    .map(
      (word) => word[0].toUpperCase() + word.slice(1, word.length).toLowerCase()
    )
    .join(" ");
}

export default titleize;
