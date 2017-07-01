function createSlideshow(options) {
    var renderMath = function() {
        renderMathInElement(document.body, {
            delimiters: [ // mind the order of delimiters(!?)
                {left: "$$", right: "$$", display: true},
                {left: "$", right: "$", display: false},
                {left: "\\[", right: "\\]", display: true},
                {left: "\\(", right: "\\)", display: false},
            ]});
    };
    return remark.create(options, renderMath);
}
