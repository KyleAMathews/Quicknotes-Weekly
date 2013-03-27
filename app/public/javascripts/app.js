(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.brunch = true;
})();

window.require.register("app", function(exports, require, module) {
  var Application, Questions;

  Questions = require('collections/questions');

  module.exports = Application = {
    initialize: function() {
      var Router;
      Router = require('router');
      this.router = new Router();
      this.collections = {};
      this.collections.questions = new Questions();
      this.collections.questions.fetch();
      this.eventBus = _.extend({}, Backbone.Events);
      return this.eventBus.on('all', function(eventName, args) {
        return console.log('new event on the eventBus: ' + eventName);
      });
    }
  };

  window.app = Application;
  
});
window.require.register("backbone_extensions", function(exports, require, module) {
  
  Backbone.View.prototype.close = function() {
    this.off();
    this.remove();
    this.closeChildrenViews();
    if (this.onClose) {
      return this.onClose();
    }
  };

  Backbone.View.prototype.closeChildrenViews = function() {
    if (this.children) {
      _.each(this.children, function(childView) {
        if (childView.close != null) {
          return childView.close();
        }
      });
      return this.children = [];
    }
  };

  Backbone.View.prototype.addChildView = function(childView) {
    if (!this.children) {
      this.children = [];
    }
    this.children.push(childView);
    return childView;
  };
  
});
window.require.register("collections/questions", function(exports, require, module) {
  var Question, Questions,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Question = require('models/question');

  module.exports = Questions = (function(_super) {

    __extends(Questions, _super);

    function Questions() {
      return Questions.__super__.constructor.apply(this, arguments);
    }

    Questions.prototype.url = '/questions';

    Questions.prototype.model = Question;

    Questions.prototype.comparator = function(question) {
      return question.get('order');
    };

    Questions.prototype.notSent = function() {
      return this.filter(function(question) {
        return !(question.get('sent') != null);
      });
    };

    return Questions;

  })(Backbone.Collection);
  
});
window.require.register("initialize", function(exports, require, module) {
  var application;

  application = require('./app');

  require('backbone_extensions');

  $(function() {
    application.initialize();
    return Backbone.history.start();
  });
  
});
window.require.register("models/question", function(exports, require, module) {
  var Question,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Question = (function(_super) {

    __extends(Question, _super);

    function Question() {
      return Question.__super__.constructor.apply(this, arguments);
    }

    return Question;

  })(Backbone.Model);
  
});
window.require.register("router", function(exports, require, module) {
  var QuestionsView, Router,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  QuestionsView = require('views/questions_view');

  module.exports = Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'questions'
    };

    Router.prototype.questions = function() {
      var questionsView;
      questionsView = new QuestionsView({
        collection: app.collections.questions
      });
      return $('body').html(questionsView.render().el);
    };

    return Router;

  })(Backbone.Router);
  
});
window.require.register("views/question_view", function(exports, require, module) {
  var QuestionView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = QuestionView = (function(_super) {

    __extends(QuestionView, _super);

    function QuestionView() {
      return QuestionView.__super__.constructor.apply(this, arguments);
    }

    QuestionView.prototype.tagName = 'li';

    QuestionView.prototype.initialize = function() {
      this.listenTo(this.model, 'all', this.render);
      return this.listenTo(this.model, 'destroy', this.destroy);
    };

    QuestionView.prototype.events = {
      'dblclick': 'editMode',
      'click button.save-question': 'saveQuestion',
      'click button.delete-question': 'deleteQuestion'
    };

    QuestionView.prototype.render = function() {
      this.mode = 'normal';
      this.$el.html(this.model.get('question'));
      this.$el.data('id', this.model.id);
      return this;
    };

    QuestionView.prototype.renderDblClick = function() {
      this.mode = 'edit';
      return this.$el.html("<div class='edit-mode'>      <input value='" + (this.model.get('question')) + "' />      <button class='save-question'>Save</button><button class='delete-question'>Delete Question</button>      </div>      ");
    };

    QuestionView.prototype.editMode = function() {
      if (this.mode === "normal") {
        return this.renderDblClick();
      }
    };

    QuestionView.prototype.saveQuestion = function() {
      var newQuestion;
      newQuestion = this.$('input').val();
      this.model.save({
        question: newQuestion
      });
      return this.render();
    };

    QuestionView.prototype.deleteQuestion = function() {
      return this.model.destroy();
    };

    QuestionView.prototype.destroy = function() {
      return this.remove();
    };

    return QuestionView;

  })(Backbone.View);
  
});
window.require.register("views/questions_view", function(exports, require, module) {
  var QuestionView, QuestionsTemplate, QuestionsView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  QuestionsTemplate = require('views/templates/questions');

  QuestionView = require('views/question_view');

  module.exports = QuestionsView = (function(_super) {

    __extends(QuestionsView, _super);

    function QuestionsView() {
      return QuestionsView.__super__.constructor.apply(this, arguments);
    }

    QuestionsView.prototype.id = 'questions-view';

    QuestionsView.prototype.initialize = function() {
      return this.listenTo(this.collection, 'sync reset', this.render);
    };

    QuestionsView.prototype.events = {
      'click button.add-question': 'addQuestion',
      'keypress input': 'keypressHandler'
    };

    QuestionsView.prototype.render = function() {
      var question, questionView, _i, _len, _ref,
        _this = this;
      this.$el.html(QuestionsTemplate());
      _ref = this.collection.notSent();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        question = _ref[_i];
        questionView = this.addChildView(new QuestionView({
          model: question
        }));
        this.$('ul.questions').append(questionView.render().el);
      }
      this.$('ul').off();
      this.$('ul').sortable();
      this.$('ul').on('sortupdate', function() {
        return _this.saveNewOrder();
      });
      _.defer(function() {
        return _this.$('input').focus();
      });
      return this;
    };

    QuestionsView.prototype.keypressHandler = function(e) {
      if (e.which === 13) {
        return this.addQuestion();
      }
    };

    QuestionsView.prototype.addQuestion = function() {
      var question;
      question = this.$('input').val();
      return this.collection.create({
        question: question,
        order: this.collection.length
      });
    };

    QuestionsView.prototype.saveNewOrder = function() {
      var id, ids, index, _i, _len,
        _this = this;
      ids = [];
      this.$('ul li').each(function(index, result) {
        return ids.push($(result).data('id'));
      });
      for (index = _i = 0, _len = ids.length; _i < _len; index = ++_i) {
        id = ids[index];
        this.collection.get(id).save('order', index);
      }
      return this.collection.sort();
    };

    return QuestionsView;

  })(Backbone.View);
  
});
window.require.register("views/templates/questions", function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
      
        __out.push('<div id="content">\n  <h2>Upcoming questions</h2>\n  <ul class="questions"></ul>\n  <input>\n  <button class="add-question">Add</button>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
});
