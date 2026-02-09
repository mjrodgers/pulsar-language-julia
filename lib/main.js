exports.activate = function () {
  if (!atom.grammars.addInjectionPoint) return;

  // atom.grammars.addInjectionPoint("source.julia", {
  //   type: "docstring",
  //
  //   language(docstring) {
  //
  //   }
  // })
};

exports.consumeHyperlinkInjection = (hyperlink) => {
  hyperlink.addInjectionPoint('source.julia', {
    types: ['comment', 'string_literal']
  });
};

exports.consumeTodoInjection = (todo) => {
  todo.addInjectionPoint('source.julia', { types: ['line_comment'] });
};
