var options = {
    highlightStyle: 'googlecode',
    highlightSpans: true,
    highlightLines: false,
    ratio: '16:9',
    navigation: {
        scroll: false,
        touch: true,
        click: false,
    }
};
var renderMath = function() {
    renderMathInElement(document.body, {
        delimiters: [ // mind the order of delimiters(!?)
            {left: "$$", right: "$$", display: true},
            {left: "$", right: "$", display: false},
            {left: "\\[", right: "\\]", display: true},
            {left: "\\(", right: "\\)", display: false},
        ]});
};
//var slideshow = remark.create(options, renderMath);
var slideshow = remark.create(options);
