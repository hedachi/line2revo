// Generated by CoffeeScript 1.12.7
var Controller, PopupWindow, SavedToggleButton, Simulator, with_scroll;

Simulator = (function() {
  function Simulator(plus, simulation_number, try_times, marble_count) {
    this.plus = plus;
    this.simulation_number = simulation_number;
    this.try_times = try_times;
    this.marble_count = marble_count;
    this.results = [];
  }

  Simulator.prototype.show_result = function(result) {};

  Simulator.prototype.show_message = function(message) {
    return $('.result_area').append("<div>" + message + "</div>");
  };

  Simulator.get_data = function(plus) {
    var data;
    data = this.DATA[plus];
    return {
      percent: data[0],
      money: data[1],
      scroll: data[2],
      marble: data[3]
    };
  };

  Simulator.DATA = [[100, 3400, 1, 0], [100, 3400, 1, 0], [100, 3400, 1, 0], [90, 3400, 1, 1], [80, 3400, 1, 1], [70, 16700, 2, 2], [60, 16700, 2, 2], [50, 16700, 2, 3], [45, 16700, 2, 3], [45, 16700, 2, 4], [45, 33400, 3, 4], [45, 33400, 3, 5], [45, 33400, 3, 5], [40, 33400, 3, 6], [40, 33400, 3, 6], [40, 33400, 4, 7], [40, 66700, 4, 7], [40, 66700, 4, 8], [35, 66700, 4, 8], [35, 66700, 4, 9], [35, 66700, 5, 9], [35, 66700, 5, 10], [35, 66700, 5, 10], [30, 66700, 5, 11], [30, 66700, 5, 11], [30, 66700, 6, 12], [30, 100000, 6, 12], [30, 100000, 6, 13], [25, 100000, 6, 13], [25, 100000, 6, 14]];

  Simulator.execute_count = 0;

  Simulator.EXECUTE_COUNT_LIMIT = 0;

  Simulator.prototype.exec = function(target_plus) {
    var before_plus, data, is_success, with_marble;
    if (Simulator.execute_count > Simulator.EXECUTE_COUNT_LIMIT) {
      return [this.results, false];
    }
    this.used_scroll_num = 0;
    this.used_money = 0;
    this.result_process = [];
    this.result_process.push({
      plus: new Number(this.plus),
      is_success: null
    });
    while (true) {
      Simulator.execute_count++;
      if (target_plus > this.plus) {
        data = this.constructor.get_data(this.plus);
        this.used_scroll_num += data.scroll;
        this.used_money += data.money;
        before_plus = this.plus;
        is_success = (data.percent / 100) >= Math.random();
        with_marble = this.marble_count >= data.marble;
        if (with_marble) {
          this.marble_count = this.marble_count - data.marble;
        }
        if (is_success) {
          this.plus++;
        } else if (with_marble) {

        } else if (this.plus === 30 || this.plus % 10 !== 0) {
          this.plus--;
        }
        this.result_process.push({
          plus: new Number(this.plus),
          is_success: is_success,
          with_marble: with_marble
        });
      } else {
        this.stock_result();
        break;
      }
    }
    return [this.results, true];
  };

  Simulator.prototype.stock_result = function() {
    return this.results.push([this.simulation_number, this.result_process.length - 1, this.used_scroll_num, this.used_money, this.result_process]);
  };

  return Simulator;

})();

with_scroll = false;

Controller = (function() {
  function Controller() {}

  Controller.LUCKS = {
    'good': '幸運',
    'normal': '普通',
    'bad': '不運'
  };

  Controller.results = [];

  Controller.initialize = function() {
    $('span.result_plus').text($('#plus').val());
    $('span.result_plus_target').text($('#plus_target').val());
    Simulator.EXECUTE_COUNT_LIMIT = parseInt($('#execute_count').val());
    return $('table#result tr').not('#result_area_header').detach();
  };

  Controller.get_average_of_results = function(index) {
    var i, ref, result, sum;
    sum = 0;
    ref = this.results;
    for (i in ref) {
      result = ref[i];
      sum += result[index];
    }
    return sum / this.results.length;
  };

  Controller.finalize = function() {
    var jp, luck, ref, results, used_money_average;
    ref = this.LUCKS;
    results = [];
    for (luck in ref) {
      jp = ref[luck];
      $("#average_enhance_times_" + luck).text(this.get_average_of_results(1).toFixed(1));
      $("#average_used_scroll_num_" + luck).text(this.get_average_of_results(2).toFixed(1));
      used_money_average = this.get_average_of_results(3);
      $("#average_used_money_" + luck).text((used_money_average / 10000).toFixed(1));
      $("#average_used_money_not_weapon_" + luck).text((used_money_average / 4 / 10000).toFixed(1));
      Simulator.execute_count = 0;
      $('span.result_execute_times').text($('td.simulation_number').last().text());
      results.push($('input.show_details').on('click', function(e) {
        var result_process, text;
        if (!$(e.target).data('opened')) {
          result_process = $(e.target).data('details');
          text = result_process.map(function(result) {
            return "<span class='is_success is_success_" + result.is_success + " " + (result.with_marble ? 'marble' : void 0) + "'>+" + result.plus + "</span>";
          }).join(' →');
          $(e.target).parent().parent().after("<tr><td colspan='6'>" + text + "</td></tr>");
          return $(e.target).data('opened', '1');
        } else {
          $(e.target).data('opened', '');
          return $(e.target).parent().parent().next().detach();
        }
      }));
    }
    return results;
  };

  Controller.execute = function() {
    var i, is_continuable, j, ref, ret, sim, try_times;
    this.initialize();
    try_times = parseInt($('#simulation_type').val());
    $('th#result_details').toggle(this.show_details());
    i = 0;
    for (i = j = 1, ref = try_times; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      sim = new Simulator($('#plus').val(), i, try_times, parseInt($('#marble_count').val()));
      i++;
      ret = sim.exec(parseInt($('#plus_target').val()));
      this.results.push(ret[0][0]);
      is_continuable = ret[1];
      if (!is_continuable) {
        break;
      }
    }
    return this.finalize();
  };

  Controller.show_details = function() {
    return true;
  };

  return Controller;

})();

PopupWindow = (function() {
  function PopupWindow() {}

  PopupWindow.show = function() {
    return $('#popup_window_base').show();
  };

  PopupWindow.hide = function() {
    return $('#popup_window_base').hide();
  };

  PopupWindow.set_title = function(title) {
    return $('.popup_window_title').html(title);
  };

  PopupWindow.set_content = function(content) {
    return $('.popup_window_content').html(content);
  };

  PopupWindow.init = function() {
    $('#explain').click((function(_this) {
      return function() {
        _this.set_title('このデータは何？');
        _this.set_content;
        return _this.show();
      };
    })(this));
    return $('#close_popup_window').click(function() {
      return PopupWindow.hide();
    });
  };

  return PopupWindow;

})();

SavedToggleButton = (function() {
  function SavedToggleButton() {}

  SavedToggleButton.set = function(button_selector, target_selector) {
    this.reflect_local_storage(button_selector, target_selector);
    return $(button_selector).click((function(_this) {
      return function() {
        _this.toggle_local_storage(button_selector, target_selector);
        return _this.reflect_local_storage(button_selector, target_selector);
      };
    })(this));
  };

  SavedToggleButton.get_key = function(button_selector, target_selector) {
    return button_selector + "___" + target_selector;
  };

  SavedToggleButton.toggle_local_storage = function(button_selector, target_selector) {
    var is_visible, key;
    key = this.get_key(button_selector, target_selector);
    is_visible = localStorage.getItem(key);
    if (is_visible) {
      return localStorage.removeItem(key);
    } else {
      return localStorage.setItem(key, '1');
    }
  };

  SavedToggleButton.reflect_local_storage = function(button_selector, target_selector) {
    var is_visible, key;
    key = this.get_key(button_selector, target_selector);
    is_visible = localStorage.getItem(key);
    if (is_visible) {
      return $(target_selector).hide();
    } else {
      return $(target_selector).show();
    }
  };

  return SavedToggleButton;

})();

$(function() {
  var i, j, k;
  for (i = j = 0; j <= 29; i = ++j) {
    $('#plus').append("<option value='" + i + "'>" + i + "</option>");
  }
  for (i = k = 1; k <= 30; i = ++k) {
    $('#plus_target').append("<option value='" + i + "'>" + i + "</option>");
  }
  $('#plus').val(5 + Math.floor(Math.random() * 5));
  $('#plus_target').val(parseInt($('#plus').val()) + 1);
  $('#run').click(function() {
    return Controller.execute();
  });
  $('#toggle_details').click(function() {
    return $('table#result').toggle();
  });
  $('#plus').change(function() {
    $('#plus_target').val(parseInt($('#plus').val()) + 1);
    return Controller.execute();
  });
  $('#plus_target').change(function() {
    return Controller.execute();
  });
  $('#simulation_type').change(function() {
    return Controller.execute();
  });
  SavedToggleButton.set('#toggle_settings', '.settings');
  Controller.execute();
  return PopupWindow.init();
});
