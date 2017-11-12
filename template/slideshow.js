var options = {
    sourceUrl: 'slide.md',
    highlightStyle: 'googlecode',
    highlightSpans: true,
    highlightLines: true,
    ratio: '16:9',
    navigation: {
        scroll: false,
        touch: false,
        click: false,
    }
};
function createSlide() {
    return remark.create(options);
};
function createKatexSlide() {
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
var slideshow = createSlide();
// var slideshow = createKatexSlide();
