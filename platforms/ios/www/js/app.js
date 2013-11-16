// Generated by CoffeeScript 1.6.3
(function() {
  var Data, currentDataVersion, defaultData, padNumber, todaysDateKey;

  window.App = Ember.Application.create();

  App.deferReadiness();

  document.addEventListener("deviceready", function() {
    return App.advanceReadiness();
  });

  App.Router.map(function() {
    this.route('new');
    return this.route('manage');
  });

  currentDataVersion = 1;

  defaultData = {
    "version": 1,
    "goals": []
  };

  /*
  {
      version: 1,
      goals: [
          {
              name: string
              trackNumber: boolean
              lastCompletedOn: "year.month.day" or null e.g. "2012.11.06"
              frequency: {
                  interval: string in set ['month', 'day', 'year']
                  daysPerPeriod: integer
                  excludeWeekends: boolean
              }
              entries: [
                  {
                      date: "year.month.day",
                      numberValue: number (this field only exists on goals with 'trackNumber' set to true)
                  }
                  ...
              ]
          }
          ...
      ]
  }
  */


  Data = {
    dataLoadedPromise: new $.Deferred(),
    initialize: function(dataObject) {
      var goal;
      this.goals = Ember.A();
      this.goals = (function() {
        var _i, _len, _ref, _results;
        _ref = dataObject.goals;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          goal = _ref[_i];
          _results.push(this.goals.pushObject(this.goalFromJson(goal)));
        }
        return _results;
      }).call(this);
      return this.dataLoadedPromise.resolve();
    },
    allGoals: function() {
      var goalsPromise,
        _this = this;
      goalsPromise = new $.Deferred();
      this.dataLoadedPromise.then(function() {
        return goalsPromise.resolve(_this.goals);
      });
      return goalsPromise.promise();
    },
    newGoal: function(_arg) {
      var daysPerPeriod, excludeWeekends, goal, interval, name, trackNumber;
      name = _arg.name, trackNumber = _arg.trackNumber, interval = _arg.interval, daysPerPeriod = _arg.daysPerPeriod, excludeWeekends = _arg.excludeWeekends;
      if (this.findGoal(name)) {
        alert('Duplicate goal name');
        return false;
      } else {
        goal = App.GoalModel.create({
          name: name,
          trackNumber: trackNumber || false,
          entries: [],
          lastCompletedOn: null,
          frequency: {
            interval: interval,
            daysPerPeriod: daysPerPeriod || 1,
            excludeWeekends: excludeWeekends || false
          }
        });
        this.goals.pushObject(goal);
        this.saveGoals();
        return true;
      }
    },
    findGoal: function(name) {
      return _.find(this.goals, function(goal) {
        return goal.name === name;
      });
    },
    saveGoals: function() {
      var json;
      json = JSON.stringify({
        version: currentDataVersion,
        goals: this.getGoalsJsonArray()
      });
      return this.writeJsonToFile(json);
    },
    getGoalsJsonArray: function() {
      var goal, _i, _len, _ref, _results;
      _ref = this.goals;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        goal = _ref[_i];
        _results.push(this.goalToJson(goal));
      }
      return _results;
    },
    goalFromJson: function(json) {
      return App.GoalModel.create(json);
    },
    goalToJson: function(goal) {
      return {
        name: goal.name,
        trackNumber: goal.trackNumber,
        lastCompletedOn: goal.lastCompletedOn,
        entries: goal.entries,
        frequency: {
          interval: goal.frequency.interval,
          daysPerPeriod: goal.frequency.daysPerPeriod,
          excludeWeekends: goal.frequency.excludeWeekends
        }
      };
    },
    readDataFromFile: function() {
      var fileReadFailed, fileReadSucceeded,
        _this = this;
      fileReadFailed = function(error) {
        console.log(error);
        return _this.initialize(defaultData);
      };
      fileReadSucceeded = function(event) {
        try {
          return _this.initialize(JSON.parse(event.target.result));
        } catch (_error) {
          return fileReadFailed();
        }
      };
      return window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, function(fs) {
        console.log(fs.root.fullPath);
        return fs.root.getFile("goals.json", null, function(fileEntry) {
          return fileEntry.file(function(file) {
            var reader;
            reader = new FileReader();
            reader.onerror = fileReadFailed;
            reader.onload = fileReadSucceeded;
            return reader.readAsText(file);
          }, fileReadFailed);
        }, fileReadFailed);
      }, fileReadFailed);
    },
    writeJsonToFile: function(json) {
      var fileWriteFailed,
        _this = this;
      fileWriteFailed = function(error) {
        return alert("Error occurred while saving: " + error);
      };
      return window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, function(fs) {
        return fs.root.getFile("goals.json", {
          create: true,
          exclusive: false
        }, function(fileEntry) {
          return fileEntry.createWriter(function(writer) {
            writer.write(json);
            return console.log('write succeeded');
          }, fileWriteFailed);
        }, fileWriteFailed);
      }, fileWriteFailed);
    }
  };

  document.addEventListener("deviceready", function() {
    return Data.readDataFromFile();
  });

  App.GoalModel = Ember.Object.extend({
    addEntry: function(goalValue) {
      var entry;
      entry = {
        date: todaysDateKey(),
        goalValue: goalValue
      };
      this.get('entries').unshiftObject(entry);
      this.set('lastCompletedOn', entry.date);
      return Data.saveGoals();
    }
  });

  App.GoalView = Ember.View.extend({
    classNames: ['goal-list-entry']
  });

  App.GoalController = Ember.ObjectController.extend({
    actions: {
      complete: function() {
        return this.get('model').addEntry(this.get('numberInput'));
      }
    },
    hasEntryForToday: function() {
      return todaysDateKey() === this.get('lastCompletedOn');
    }
  });

  padNumber = function(number) {
    if (number < 10) {
      return "0" + number;
    } else {
      return "" + number;
    }
  };

  todaysDateKey = function() {
    var day, month, today, year;
    today = new Date();
    year = padNumber(today.getFullYear());
    month = padNumber(today.getMonth() + 1);
    day = padNumber(today.getDate());
    return "" + year + "." + month + "." + day;
  };

  App.IndexRoute = Ember.Route.extend({
    model: function() {
      return Data.allGoals();
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
      return 0 < this.get('todaysGoals.length');
    }),
    thisWeeksGoals: Ember.computed('model.@each', function() {
      return this.filterBy('week');
    }),
    hasWeeklyGoals: Ember.computed('thisWeeksGoals.length', function() {
      return 0 < this.get('thisWeeksGoals.length');
    }),
    thisMonthsGoals: Ember.computed('model.@each', function() {
      return this.filterBy('month');
    }),
    hasMonthlyGoals: Ember.computed('thisMonthsGoals.length', function() {
      return 0 < this.get('thisMonthsGoals.length');
    })
  });

  App.ManageRoute = Ember.Route.extend({
    model: function() {
      return Data.allGoals();
    }
  });

  App.ManageController = Ember.ArrayController.extend({
    actions: {
      "delete": function(goal) {}
    }
  });

  App.NewRoute = Ember.Route.extend({
    actions: {
      save: function() {
        return this.transitionTo('index');
      },
      cancel: function() {
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
    saveForm: function() {
      return Data.newGoal({
        name: this.get('goalName'),
        trackNumber: this.get('addNumberInput'),
        interval: this.get('goalFrequency'),
        daysPerPeriod: this.get('daysPerPeriod'),
        excludeWeekends: this.get('excludeWeekends')
      });
    },
    clearForm: function() {
      this.set('goalName', '');
      this.set('addNumberInput', false);
      this.set('goalFrequency', '');
      this.set('daysPerPeriod', '');
      this.set('excludeWeekends', false);
      return true;
    },
    actions: {
      save: function() {
        var result;
        result = this.saveForm();
        if (result) {
          this.clearForm();
        }
        return result;
      },
      cancel: function() {
        return this.clearForm();
      }
    }
  });

}).call(this);
