// Generated by CoffeeScript 1.6.3
(function() {
  var todaysDateKey,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.App = Ember.Application.create();

  App.Router.map(function() {
    return this.route('new');
  });

  App.GoalModel = Ember.Object.extend();

  window.Data = {
    loadGoals: function() {
      this.loadData();
      return this.goalsAsArray();
    },
    saveGoal: function(description) {
      var Error;
      this.loadData();
      try {
        this.addModelName(description.name);
        this.saveModel(description);
        return true;
      } catch (_error) {
        Error = _error;
        console.log(Error);
        alert(Error);
        return false;
      }
    },
    getGoalsList: function() {
      return JSON.parse(localStorage.getItem('goals')) || [];
    },
    buildGoal: function(goalName) {
      var description, model;
      description = JSON.parse(localStorage.getItem("goals." + goalName)) || {};
      model = App.GoalModel.create(description);
      this.goals[description.name] = model;
      return model;
    },
    loadData: function() {
      var goalName, _i, _len, _ref;
      if (!this.initialized) {
        this.goalNames = this.getGoalsList();
        this.goals = {};
        _ref = this.goalNames;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          goalName = _ref[_i];
          this.buildGoal(goalName);
        }
        return this.initialized = true;
      }
    },
    addModelName: function(name) {
      if (!name || __indexOf.call(this.goalNames, name) >= 0) {
        throw "Duplicate goal: " + name;
      }
      this.goalNames.push(name);
      return localStorage.setItem('goals', JSON.stringify(this.goalNames));
    },
    saveModel: function(description) {
      var model;
      model = App.GoalModel.create(description);
      this.goals[description.name] = model;
      return localStorage.setItem("goals." + description.name, JSON.stringify(description));
    },
    goalsAsArray: function() {
      return _.collect(this.goals, function(goal) {
        return goal;
      });
    }
  };

  App.GoalView = Ember.View.extend({
    classNames: ['goal-list-entry']
  });

  App.GoalController = Ember.ObjectController.extend({
    checkbox: Ember.computed(function() {
      return this.hasEntryForToday();
    }),
    isCheckbox: Ember.computed('input', function() {
      return 'checkbox' === this.get('input');
    }),
    isNumber: Ember.computed('input', function() {
      return 'number' === this.get('input');
    }),
    checkboxChange: Ember.observer('checkbox', function() {
      debugger;
    }),
    hasEntryForToday: function() {
      return todaysDateKey() === this.get('lastCompletedOn');
    }
  });

  todaysDateKey = function() {
    var day, month, today, year;
    today = new Date();
    year = today.getFullYear();
    month = today.getMonth() + 1;
    day = today.getDate();
    return "" + year + "." + month + "." + day;
  };

  App.IndexRoute = Ember.Route.extend({
    model: function() {
      return Data.loadGoals();
    }
  });

  App.IndexController = Ember.ArrayController.extend({
    days: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    today: Ember.computed(function() {
      var day, month, today, weekday;
      today = new Date();
      weekday = this.days[today.getDay()];
      month = this.months[today.getMonth()];
      day = today.getDate();
      return "" + weekday + " " + month + " " + day;
    }),
    isWeekend: Ember.computed(function() {
      var dayOfWeek;
      dayOfWeek = this.days[new Date().getDay()];
      return dayOfWeek === 'Saturday' || dayOfWeek === 'Sunday';
    }),
    hasGoals: Ember.computed('length', function() {
      return 0 < this.get('length');
    }),
    filterBy: function(filter) {
      var goal, _i, _len, _ref, _results;
      _ref = this.get('model');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        goal = _ref[_i];
        if (goal.frequency.interval === filter && this.checkWeekend(goal)) {
          _results.push(goal);
        }
      }
      return _results;
    },
    checkWeekend: function(goal) {
      return !goal.frequency.excludeWeekends || !this.get('isWeekend');
    },
    todaysGoals: Ember.computed('model.@each', function() {
      return this.filterBy('day');
    }),
    hasDailyGoals: Ember.computed('todaysGoals.length', function() {
      return this.get('todaysGoals.length');
    }),
    thisWeeksGoals: Ember.computed('model.@each', function() {
      return this.filterBy('week');
    }),
    hasWeeklyGoals: Ember.computed('thisWeeksGoals.length', function() {
      return this.get('thisWeeksGoals.length');
    }),
    thisMonthsGoals: Ember.computed('model.@each', function() {
      return this.filterBy('month');
    }),
    hasMonthlyGoals: Ember.computed('thisMonthsGoals.length', function() {
      return this.get('thisMonthsGoals.length');
    })
  });

  App.NewRoute = Ember.Route.extend({
    actions: {
      save: function() {
        return this.transitionTo('index');
      }
    }
  });

  App.NewController = Ember.Controller.extend({
    frequencyOptions: [
      {
        label: 'Every Day',
        id: 'day'
      }, {
        label: 'X Days a Week',
        id: 'week'
      }, {
        label: 'X Days a Month',
        id: 'month'
      }
    ],
    inputTypeOptions: [
      {
        label: 'Checkbox',
        id: 'checkbox'
      }, {
        label: 'Number',
        id: 'number'
      }
    ],
    daysPerPeriodSelection: Ember.computed('goalFrequency', function() {
      var _ref;
      return (_ref = this.get('goalFrequency')) === 'week' || _ref === 'month';
    }),
    actions: {
      save: function() {
        return Data.saveGoal({
          name: this.get('goalName'),
          input: this.get('inputType'),
          entries: [],
          lastCompletedOn: null,
          frequency: {
            interval: this.get('goalFrequency'),
            daysPerPeriod: this.get('daysPerPeriod') || 1,
            excludeWeekends: this.get('excludeWeekends') || false
          }
        });
      }
    }
  });

}).call(this);
