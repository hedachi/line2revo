// Generated by CoffeeScript 1.12.7
(function() {
  var AbstractSimulator, Controller, TargetSimulator, with_scroll,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  AbstractSimulator = (function() {
    AbstractSimulator.log_count = 0;

    function AbstractSimulator(plus, simulation_number, try_times) {
      this.plus = plus;
      this.simulation_number = simulation_number;
      this.try_times = try_times;
    }

    AbstractSimulator.prototype.show_result = function(result) {};

    AbstractSimulator.prototype.show_message = function(message) {
      return $('.result_area').append("<div>" + message + "</div>");
    };

    AbstractSimulator.get_data = function(plus) {
      var data;
      data = this.DATA[plus];
      console.log("get_data of +" + plus);
      return {
        percent: data[0],
        money: data[1],
        scroll: data[2],
        marble: data[3]
      };
    };

    AbstractSimulator.DATA = [[100, 3400, 1, 0], [100, 3400, 1, 0], [100, 3400, 1, 0], [90, 3400, 1, 1], [80, 3400, 1, 1], [70, 16700, 2, 2], [60, 16700, 2, 2], [50, 16700, 2, 3], [45, 16700, 2, 3], [45, 16700, 2, 4], [45, 33400, 3, 4], [45, 33400, 3, 5], [45, 33400, 3, 5], [40, 33400, 3, 6], [40, 33400, 3, 6], [40, 33400, 4, 7], [40, 66700, 4, 7], [40, 66700, 4, 8], [35, 66700, 4, 8], [35, 66700, 4, 9], [35, 66700, 5, 9], [35, 66700, 5, 10], [35, 66700, 5, 10], [30, 66700, 5, 11], [30, 66700, 5, 11], [30, 66700, 6, 12], [30, 100000, 6, 12], [30, 100000, 6, 13], [25, 100000, 6, 13], [25, 100000, 6, 14]];

    return AbstractSimulator;

  })();

  TargetSimulator = (function(superClass) {
    extend(TargetSimulator, superClass);

    function TargetSimulator() {
      return TargetSimulator.__super__.constructor.apply(this, arguments);
    }

    TargetSimulator.prototype.exec = function(target_plus) {
      var before_plus, data, is_success, results;
      this.used_scroll_num = 0;
      this.used_money = 0;
      this.result_process = [new Number(this.plus)];
      results = [];
      while (true) {
        if (target_plus > this.plus) {
          data = this.constructor.get_data(this.plus);
          this.used_scroll_num += data.scroll;
          this.used_money += data.money;
          before_plus = this.plus;
          is_success = (data.percent / 100) >= Math.random();
          if (is_success) {
            this.plus++;
          } else if (this.plus === 30 || this.plus % 10 !== 0) {
            this.plus--;
          }
          results.push(this.result_process.push(new Number(this.plus)));
        } else {
          this.show_result();
          break;
        }
      }
      return results;
    };

    TargetSimulator.prototype.show_result = function() {
      var $result_tr, text;
      $result_tr = $('<tr></tr>');
      $result_tr.append($("<td>" + this.simulation_number + "</td>"));
      $result_tr.append($("<td class='enhance_times'>" + (this.result_process.length - 1) + "</td>"));
      $result_tr.append($("<td class='used_scroll_num'>" + this.used_scroll_num + "</td>"));
      $result_tr.append($("<td class='used_money'>" + this.used_money + "</td>"));
      if (this.try_times <= 10) {
        text = this.result_process.map(function(plus) {
          return " +" + plus + " ";
        }).join('→');
        $result_tr.append($("<td><input class='show_details' type='button' value='詳細' data-details='" + text + "'/></td>"));
      }
      return $('table#result').append($result_tr);
    };

    return TargetSimulator;

  })(AbstractSimulator);

  with_scroll = false;

  Controller = (function() {
    function Controller() {}

    Controller.prototype.get_sum = function(selector) {
      var sum;
      sum = 0;
      $(selector).each(function(index, element) {
        return sum += parseInt(element.innerHTML);
      });
      return sum;
    };

    Controller.prototype.get_average = function(selector) {
      var average;
      average = this.get_sum(selector) / $(selector).size();
      return Math.round(average * 10) / 10;
    };

    Controller.prototype.insert_average = function() {
      var $result_tr;
      $result_tr = $('<tr></tr>');
      $result_tr.append($("<td>平均</td>"));
      $result_tr.append($("<td class='enhance_times'>" + (this.get_average('.enhance_times')) + "</td>"));
      $result_tr.append($("<td class='used_scroll_num'>" + (this.get_average('.used_scroll_num')) + "</td>"));
      $result_tr.append($("<td class='used_money'>" + (this.get_average('.used_money')) + "</td>"));
      return $('tr#result_area_header').after($result_tr);
    };

    Controller.prototype.reset = function() {
      return $('table#result tr').not('#result_area_header').detach();
    };

    Controller.prototype.execute = function() {
      var i, j, ref, sim, try_times;
      this.reset();
      if (with_scroll) {
        sim = new ScrollSimulator($('#plus').val());
        return sim.exec(Math.ceil(Math.random() * 100));
      } else {
        try_times = parseInt($('#simulation_type').val());
        $('th#result_details').toggle(try_times <= 10);
        for (i = j = 1, ref = try_times; 1 <= ref ? j < ref : j > ref; i = 1 <= ref ? ++j : --j) {
          sim = new TargetSimulator($('#plus').val(), i, try_times);
          sim.exec(parseInt($('#plus_target').val()));
        }
        return this.insert_average();
      }
    };

    return Controller;

  })();

  $(function() {
    var after_plus, before_plus, controller, i, j, k;
    controller = new Controller;
    for (i = j = 0; j <= 29; i = ++j) {
      $('#plus').append("<option value='" + i + "'>" + i + "</option>");
    }
    for (i = k = 1; k <= 30; i = ++k) {
      $('#plus_target').append("<option value='" + i + "'>" + i + "</option>");
    }
    before_plus = 5 + Math.floor(Math.random() * 5);
    $('#plus').val(before_plus);
    after_plus = Math.min(30, before_plus + Math.ceil(Math.random() * 3));
    $('#plus_target').val(after_plus);
    $('#run').click(function() {
      return controller.execute();
    });
    $('#plus').change(function() {
      if (parseInt($('#plus_target').val()) <= parseInt($('#plus').val())) {
        $('#plus_target').val(parseInt($('#plus').val()) + 1);
      }
      return controller.execute();
    });
    $('#plus_target').change(function() {
      return controller.execute();
    });
    controller.execute();
    return $('#close_popup_window').click(function() {
      return $('#popup_window').hide();
    });
  });

}).call(this);
