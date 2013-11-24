// Generated by CoffeeScript 1.6.3
(function() {
  var Data, Time;

  window.App = Ember.Application.create();

  if (navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)) {
    App.deferReadiness();
    document.addEventListener("deviceready", function() {
      return App.advanceReadiness();
    });
  }

  App.Router.map(function() {
    this.route('new');
    return this.route('detail', {
      path: '/detail/:goal_id'
    });
  });

  /*
  {
      version: 1
      goals: [
          {
              name: string
              trackNumber: boolean
              lastCompletedOn: ISO Date String
              frequency: {
                  interval: string in set ['month', 'day', 'year']
                  daysPerPeriod: integer
                  excludeWeekends: boolean
              }
              entries: [
                  {
                      date: ISO Date String,
                      numberValue: number (this field only exists on goals with 'trackNumber' set to true)
                  }
                  ...
              ]
          }
          ...
      ]
  }
  */


  Data = Ember.Object.extend({
    id_counter: 1,
    currentDataVersion: 1,
    defaultData: {
      "version": 1,
      "goals": []
    },
    dataLoadedPromise: new $.Deferred(),
    initialize: function(dataObject) {
      var goal;
      this.goals = Ember.A((function() {
        var _i, _len, _ref, _results;
        _ref = dataObject.goals;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          goal = _ref[_i];
          _results.push(this.goalFromJson(goal));
        }
        return _results;
      }).call(this));
      return this.dataLoadedPromise.resolve();
    },
    allGoals: function() {
      var promise,
        _this = this;
      promise = new $.Deferred();
      this.dataLoadedPromise.then(function() {
        return promise.resolve(_this.goals);
      });
      return promise.promise();
    },
    getGoalById: function(id) {
      var promise,
        _this = this;
      if (typeof id === 'string') {
        id = parseInt(id);
      }
      promise = new $.Deferred();
      this.dataLoadedPromise.then(function() {
        var goal;
        goal = _.find(_this.goals, function(g) {
          return id === g.get('id');
        });
        return promise.resolve(goal);
      });
      return promise.promise();
    },
    newGoal: function(_arg) {
      var daysPerPeriod, excludeWeekends, goal, interval, name, trackNumber;
      name = _arg.name, trackNumber = _arg.trackNumber, interval = _arg.interval, daysPerPeriod = _arg.daysPerPeriod, excludeWeekends = _arg.excludeWeekends;
      if (this.findGoalByName(name)) {
        alert('Duplicate goal name');
        return false;
      } else {
        goal = App.GoalModel.create({
          id: this.newId(),
          name: name,
          trackNumber: trackNumber || false,
          entries: [],
          lastCompletedOn: null,
          frequency: {
            interval: interval,
            daysPerPeriod: parseInt(daysPerPeriod) || 1,
            excludeWeekends: excludeWeekends || false
          }
        });
        this.goals.pushObject(goal);
        this.saveGoals();
        return true;
      }
    },
    deleteGoal: function(goal) {
      this.goals.removeObject(goal);
      return this.saveGoals();
    },
    findGoalByName: function(name) {
      return _.find(this.goals, function(goal) {
        return goal.get('name') === name;
      });
    },
    saveGoals: function() {
      var json;
      json = JSON.stringify({
        version: this.currentDataVersion,
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
      return App.GoalModel.create(json, {
        id: this.newId()
      });
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
    newId: function() {
      return this.id_counter++;
    },
    readDataFromFile: function() {
      var fileReadFailed, fileReadSucceeded,
        _this = this;
      fileReadFailed = function(error) {
        console.log(error);
        return _this.initialize(_this.defaultData);
      };
      fileReadSucceeded = function(event) {
        var error;
        try {
          _this.initialize(JSON.parse(event.target.result));
          return console.log('data read and app initialized');
        } catch (_error) {
          error = _error;
          return fileReadFailed(error);
        }
      };
      return window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, function(fs) {
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
    },
    readInFakeData: function() {
      return this.initialize({
        version: 1,
        goals: [
          {
            name: "something",
            trackNumber: false,
            lastCompletedOn: null,
            frequency: {
              interval: 'day',
              daysPerPeriod: 1,
              excludeWeekends: false
            },
            entries: [
              {
                date: "2013-11-20T05:00:00.000Z"
              }, {
                date: "2013-11-19T05:00:00.000Z"
              }, {
                date: "2013-11-18T05:00:00.000Z"
              }, {
                date: "2013-11-17T05:00:00.000Z"
              }, {
                date: "2013-11-16T05:00:00.000Z"
              }, {
                date: "2013-11-15T05:00:00.000Z"
              }, {
                date: "2013-11-14T05:00:00.000Z"
              }, {
                date: "2013-11-13T05:00:00.000Z"
              }, {
                date: "2013-11-12T05:00:00.000Z"
              }, {
                date: "2013-11-11T05:00:00.000Z"
              }, {
                date: "2013-11-10T05:00:00.000Z"
              }
            ]
          }, {
            name: "weekly test",
            trackNumber: false,
            lastCompletedOn: null,
            frequency: {
              interval: 'week',
              daysPerPeriod: 2,
              excludeWeekends: false
            },
            entries: [
              {
                date: "2013-11-19T05:00:00.000Z"
              }, {
                date: "2013-11-17T05:00:00.000Z"
              }, {
                date: "2013-11-15T05:00:00.000Z"
              }, {
                date: "2013-11-14T05:00:00.000Z"
              }, {
                date: "2013-11-13T05:00:00.000Z"
              }, {
                date: "2013-11-12T05:00:00.000Z"
              }, {
                date: "2013-11-11T05:00:00.000Z"
              }, {
                date: "2013-11-10T05:00:00.000Z"
              }, {
                date: "2013-10-31T05:00:00.000Z"
              }, {
                date: "2013-10-30T05:00:00.000Z"
              }, {
                date: "2013-10-29T05:00:00.000Z"
              }
            ]
          }
        ]
      });
    }
  });

  App.data = Data.create();

  if (navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)) {
    console.log('mobile device detected, waiting for deviceready event');
    document.addEventListener("deviceready", function() {
      console.log('deviceready fired');
      return App.data.readDataFromFile();
    });
  } else {
    jQuery(function() {
      App.data.writeJsonToFile = (function() {});
      return App.data.readInFakeData();
    });
  }

  App.DetailRoute = Ember.Route.extend({
    model: function(params) {
      return App.data.getGoalById(params.goal_id);
    },
    afterModel: function(goal) {
      if (!goal) {
        return this.transitionTo('index');
      }
    },
    actions: {
      "delete": function() {
        return this.transitionTo('index');
      }
    }
  });

  App.DetailController = Ember.ObjectController.extend({
    actions: {
      "delete": function() {
        if (confirm("Delete this goal?")) {
          App.data.deleteGoal(this.get('model'));
          return true;
        } else {
          return false;
        }
      }
    }
  });

  App.GoalListEntryView = Ember.View.extend({
    classNameBindings: [':goal-list-entry', 'goalStatus'],
    goalStatus: Ember.computed('controller.statusForThisPeriod', function() {
      return this.get('controller.statusForThisPeriod');
    })
  });

  App.GoalListEntryController = Ember.ObjectController.extend({
    actions: {
      complete: function() {
        return this.get('model').addEntry(this.get('numberInput'));
      }
    }
  });

  App.GoalModel = Ember.Object.extend({
    hasEntryForToday: Ember.computed('lastCompletedOn', function() {
      return App.time.todaysKey() === this.get('lastCompletedOn');
    }),
    nonDayPeriodGoal: Ember.computed('frequency.interval', function() {
      return 'day' !== this.get('frequency.interval');
    }),
    frequencyDescription: Ember.computed('frequency.interval', 'frequency.daysPerPeriod', function() {
      var count, interval, number, period, prelude;
      interval = this.get('frequency.interval');
      count = this.get('frequency.daysPerPeriod');
      prelude = "Meet this goal ";
      if (interval === 'day') {
        return "" + prelude + " Every Day";
      } else {
        number = (function() {
          switch (false) {
            case count !== 1:
              return "Once";
            case count !== 2:
              return "Twice";
            default:
              return "" + count + " times";
          }
        })();
        period = (function() {
          switch (false) {
            case interval !== 'week':
              return "Week";
            default:
              return "Month";
          }
        })();
        return "" + prelude + " at least " + number + " a " + period;
      }
    }),
    statusReport: Ember.computed('frequency.interval', 'entries.@each', function() {
      var count, period, plural;
      count = this.entriesCompletedThisPeriod();
      plural = count === 1 ? "" : "s";
      period = this.get('frequency.interval');
      return "This goal has been completed " + count + " time" + plural + " this " + period + ".";
    }),
    statusForThisPeriod: Ember.computed('entries.@each', 'hasEntryForToday', function() {
      var completed, daysRemaining, remaining, required;
      if ('day' === this.get('frequency.interval')) {
        if (this.get('hasEntryForToday')) {
          return 'complete';
        } else {
          return 'uncomplete';
        }
      } else {
        completed = this.entriesCompletedThisPeriod();
        required = this.get('frequency.daysPerPeriod');
        remaining = required - completed;
        daysRemaining = App.time.daysLeftInPeriod(this.get('frequency.interval'));
        if (!this.get('hasEntryForToday')) {
          daysRemaining += 1;
        }
        switch (false) {
          case !(remaining <= 0):
            return 'complete';
          case daysRemaining !== remaining:
            return 'danger';
          case !(remaining > daysRemaining):
            return 'failed';
          default:
            return 'uncomplete';
        }
      }
    }),
    goalCompleteForPeriod: function() {
      var completed;
      if ('day' === this.get('frequency.interval')) {
        return this.get('hasEntryForToday');
      } else {
        completed = this.entriesCompletedThisPeriod();
        return completed >= this.get('frequency.daysPerPeriod');
      }
    },
    addEntry: function(goalValue) {
      var entry;
      entry = {
        date: App.time.todaysKey(),
        goalValue: goalValue
      };
      this.get('entries').unshiftObject(entry);
      this.set('lastCompletedOn', entry.date);
      return App.data.saveGoals();
    },
    entriesCompletedThisPeriod: function() {
      return this.entriesForThisPeriod().length;
    },
    entriesForThisPeriod: function() {
      var currentPeriod, intervalFunction, now;
      now = moment();
      intervalFunction = 'week' === this.get('frequency.interval') ? now.weeks : now.months;
      currentPeriod = intervalFunction.apply(now);
      return _.filter(this.entries, function(entry) {
        return currentPeriod === intervalFunction.apply(moment(entry.date));
      });
    }
  });

  App.IndexRoute = Ember.Route.extend({
    model: function() {
      return App.data.allGoals();
    },
    actions: {
      detail: function(goal) {
        return this.transitionTo('detail', goal);
      }
    }
  });

  App.IndexController = Ember.ArrayController.extend({
    hasGoals: Ember.computed('length', function() {
      return 0 < this.get('length');
    }),
    filterByInterval: function(interval) {
      var _this = this;
      return _.filter(this.get('model'), function(goal) {
        return interval === goal.get('frequency.interval');
      });
    },
    filterByUnfinished: function(goals) {
      var _this = this;
      return _.filter(goals, function(goal) {
        var complete;
        complete = goal.get('hasEntryForToday') || goal.get('frequency.excludeWeekends') && App.get('time.isWeekend');
        return !complete;
      });
    },
    dailyGoals: Ember.computed('model.@each', function() {
      return this.filterByInterval('day');
    }),
    weeklyGoals: Ember.computed('model.@each', function() {
      return this.filterByInterval('week');
    }),
    monthlyGoals: Ember.computed('model.@each', function() {
      return this.filterByInterval('month');
    }),
    unfinishedDailyGoals: Ember.computed('dailyGoals.@each.hasEntryForToday', 'showAll', function() {
      if (this.get('showAll')) {
        return this.get('dailyGoals');
      } else {
        return this.filterByUnfinished(this.get('dailyGoals'));
      }
    }),
    unfinishedWeeklyGoals: Ember.computed('weeklyGoals.@each.hasEntryForToday', 'showAll', function() {
      if (this.get('showAll')) {
        return this.get('weeklyGoals');
      } else {
        return this.filterByUnfinished(this.get('weeklyGoals'));
      }
    }),
    unfinishedMonthlyGoals: Ember.computed('monthlyGoals.@each.hasEntryForToday', 'showAll', function() {
      if (this.get('showAll')) {
        return this.get('monthlyGoals');
      } else {
        return this.filterByUnfinished(this.get('monthlyGoals'));
      }
    }),
    hasDailyGoals: Ember.computed('dailyGoals.length', function() {
      return 0 < this.get('dailyGoals.length');
    }),
    hasWeeklyGoals: Ember.computed('weeklyGoals.length', function() {
      return 0 < this.get('weeklyGoals.length');
    }),
    hasMonthlyGoals: Ember.computed('monthlyGoals.length', function() {
      return 0 < this.get('monthlyGoals.length');
    }),
    hasUnfinishedDailyGoals: Ember.computed('unfinishedDailyGoals.length', function() {
      return 0 < this.get('unfinishedDailyGoals.length');
    }),
    hasUnfinishedWeeklyGoals: Ember.computed('unfinishedWeeklyGoals.length', function() {
      return 0 < this.get('unfinishedWeeklyGoals.length');
    }),
    hasUnfinishedMonthlyGoals: Ember.computed('unfinishedMonthlyGoals.length', function() {
      return 0 < this.get('unfinishedMonthlyGoals.length');
    }),
    actions: {
      toggleShowAll: function() {
        return this.set('showAll', !this.get('showAll'));
      }
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
      return App.data.newGoal({
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

  Time = Ember.Object.extend({
    todayDisplay: Ember.computed(function() {
      return this.today().format('dddd MMMM Do');
    }),
    isWeekend: Ember.computed(function() {
      var _ref;
      return (_ref = this.today().days()) === 0 || _ref === 6;
    }),
    today: function() {
      var n;
      n = moment();
      return moment({
        years: n.year(),
        months: n.month(),
        days: n.date()
      });
    },
    todaysKey: function() {
      return this.today().toISOString();
    },
    daysLeftInPeriod: function(period) {
      switch (period) {
        case 'day':
          return 0;
        case 'week':
          return this.daysLeftInWeek();
        case 'month':
          return this.daysLeftInMonth();
      }
    },
    daysLeftInWeek: function() {
      return 6 - this.today().days();
    },
    daysLeftInMonth: function() {
      var today;
      today = this.today();
      return today.daysInMonth() - today.date();
    }
  });

  App.time = Time.create();

}).call(this);
