class Simulator
  constructor: (plus, simulation_number, try_times, marble_count) ->
    @plus = plus
    @simulation_number = simulation_number
    @try_times = try_times
    @marble_count = marble_count
    @results = []
  show_result: (result) ->
  show_message: (message) ->
    $('.result_area').append "<div>#{message}</div>"
  @get_data = (plus) ->
    data = @DATA[plus]
    {
      percent: data[0]
      money: data[1]
      scroll: data[2]
      marble: data[3]
    }
  @DATA = [ #成功率,アデナ,消費スクロール数,消費マーブルの加護数
    [100,3400,1,0]
    [100,3400,1,0]
    [100,3400,1,0]
    [90,3400,1,1]
    [80,3400,1,1]
    [70,16700,2,2]
    [60,16700,2,2]
    [50,16700,2,3]
    [45,16700,2,3]
    [45,16700,2,4]
    [45,33400,3,4]
    [45,33400,3,5]
    [45,33400,3,5]
    [40,33400,3,6]
    [40,33400,3,6]
    [40,33400,4,7]
    [40,66700,4,7]
    [40,66700,4,8]
    [35,66700,4,8]
    [35,66700,4,9]
    [35,66700,5,9]
    [35,66700,5,10]
    [35,66700,5,10]
    [30,66700,5,11]
    [30,66700,5,11]
    [30,66700,6,12]
    [30,100000,6,12]
    [30,100000,6,13]
    [25,100000,6,13]
    [25,100000,6,14]
  ]
  @execute_count = 0
  @EXECUTE_COUNT_LIMIT = 0
  exec: (target_plus) ->
    if Simulator.execute_count > Simulator.EXECUTE_COUNT_LIMIT
      return [@results, false]
    @used_scroll_num = 0
    @used_money = 0
    @result_process = [] 
    @result_process.push
      plus: new Number(@plus)
      is_success: null
    loop
      Simulator.execute_count++
      if target_plus > @plus
        data = @constructor.get_data(@plus)
        @used_scroll_num += data.scroll
        @used_money += data.money
        before_plus = @plus
        is_success = (data.percent / 100) >= Math.random()
        with_marble = @marble_count >= data.marble
        if with_marble
          @marble_count = @marble_count - data.marble
        if is_success
          @plus++
        else if with_marble
          #何も起こらない
        else if @plus == 30 || @plus % 10 != 0
          @plus--
        @result_process.push
          plus: new Number(@plus)
          is_success: is_success
          with_marble: with_marble
        #console.log "+#{before_plus}からスクロール#{data.scroll}枚、#{data.money}アデナ、成功率#{data.percent}%で強化...[#{result}]#{@plus}になりました。"
      else
        #@show_result()
        @stock_result()
        break
    [@results, true]
  stock_result: ->
    @results.push [
      @simulation_number
      @result_process.length - 1
      @used_scroll_num
      @used_money
      @result_process
    ]
  #show_result: ->
  #  $result_tr = $ '<tr></tr>'
  #  $result_tr.append $ "<td class='simulation_number'>#{@simulation_number}</td>"
  #  $result_tr.append $ "<td class='enhance_times'>#{@result_process.length - 1}</td>"
  #  $result_tr.append $ "<td class='used_scroll_num'>#{@used_scroll_num}</td>"
  #  $result_tr.append $ "<td class='used_money'>#{@used_money}</td>"
  #  $result_tr.append $ "<td class='used_money_not_weapon'>#{Math.round @used_money/4}</td>"
  #  if Controller.show_details()
  #    $result_tr.append $("<td><input class='show_details' type='button' value='見る' data-details='#{JSON.stringify(@result_process)}'/></td>")
  #  $('table#result').append $result_tr

with_scroll = false

class Controller
  @LUCKS = 
    'good':'幸運'
    'normal':'普通'
    'bad':'不運'
  @initialize = ->
    $('span.result_plus').text $('#plus').val()
    $('span.result_plus_target').text $('#plus_target').val()
    #$('span.result_execute_times').text parseInt($('#simulation_type').val())
    Simulator.EXECUTE_COUNT_LIMIT = parseInt $('#execute_count').val()
    $('table#result tr').not('#result_area_header').detach()
    @results = []
  @get_average_of_results = (index, results) ->
    sum = 0
    for i, result of results
      sum += result[index]
    sum / results.length
  @finalize = ->
    @results.sort (a, b) -> a[1] - b[1]
    length = Math.floor(@results.length / 3)
    results =
      good: @results.slice(0, length)
      normal: @results.slice(length, length + length)
      bad: @results.slice(length + length)
    for luck, jp of @LUCKS
      $("#average_enhance_times_#{luck}").text @get_average_of_results(1, results[luck]).toFixed(1)
      $("#average_used_scroll_num_#{luck}").text @get_average_of_results(2, results[luck]).toFixed(1)
      used_money_average = @get_average_of_results(3, results[luck])
      $("#average_used_money_#{luck}").text (used_money_average / 10000).toFixed(1)
      $("#average_used_money_not_weapon_#{luck}").text (used_money_average / 4 / 10000).toFixed(1)
      Simulator.execute_count = 0
      $('span.result_execute_times').text $('td.simulation_number').last().text()
      $('input.show_details').on 'click', (e) ->
        if !$(e.target).data('opened')
          result_process = $(e.target).data('details')
          text = result_process.map( (result) ->
            "<span class='is_success is_success_#{result.is_success} #{if result.with_marble then 'marble'}'>+#{result.plus}</span>"
          ).join(' →')
          $(e.target).parent().parent().after("<tr><td colspan='6'>#{text}</td></tr>")
          $(e.target).data('opened', '1')
        else
          $(e.target).data('opened', '')
          $(e.target).parent().parent().next().detach()
  @execute = ->
    @initialize()
    try_times = parseInt $('#simulation_type').val()
    $('th#result_details').toggle(@show_details())
    i = 0
    #loop
    for i in [1..try_times]
      sim = new Simulator($('#plus').val(), i, try_times, parseInt($('#marble_count').val()))
      i++
      ret = sim.exec(parseInt $('#plus_target').val())
      @results.push ret[0][0] #この[0][0]はなんかおかしいんだけど、こうしないと想定通りに動かない
      is_continuable = ret[1]
      break unless is_continuable 
    @finalize()
  @show_details = ->
    #parseInt $('#simulation_type').val() <= 10
    true

class PopupWindow
  @show = ->
    $('#popup_window_base').show()
  @hide = ->
    $('#popup_window_base').hide()
  @set_title = (title) ->
    $('.popup_window_title').html title
  @set_content = (content) ->
    $('.popup_window_content').html content
  @init = ->
    $('#explain').click =>
      @set_title 'このデータは何？'
      @set_content
      @show()
    $('#close_popup_window').click -> PopupWindow.hide()

class SavedToggleButton
  @set = (button_selector, target_selector) ->
    @reflect_local_storage(button_selector, target_selector)
    $(button_selector).click =>
      @toggle_local_storage(button_selector, target_selector)
      @reflect_local_storage(button_selector, target_selector)
  @get_key = (button_selector, target_selector) ->
    "#{button_selector}___#{target_selector}"
  @toggle_local_storage = (button_selector, target_selector) ->
    key = @get_key(button_selector, target_selector)
    is_visible = localStorage.getItem(key)
    if is_visible
      localStorage.removeItem(key)
    else
      localStorage.setItem(key, '1')
  @reflect_local_storage = (button_selector, target_selector) ->
    key = @get_key(button_selector, target_selector)
    is_visible = localStorage.getItem(key)
    if is_visible
      $(target_selector).hide()
    else
      $(target_selector).show()

$ ->
  for i in [0..29]
    $('#plus').append "<option value='#{i}'>#{i}</option>"
  for i in [1..30]
    $('#plus_target').append "<option value='#{i}'>#{i}</option>"

  $('#plus').val 5 + Math.floor(Math.random() * 5)
  $('#plus_target').val parseInt($('#plus').val()) + 1

  $('#run').click -> Controller.execute()
  $('#toggle_details').click -> $('table#result').toggle()
  $('#plus').change ->
    $('#plus_target').val(parseInt($('#plus').val()) + 1)
    Controller.execute()
  $('#plus_target').change -> Controller.execute()
  $('#simulation_type').change -> Controller.execute()
  SavedToggleButton.set '#toggle_settings', '.settings'
  Controller.execute()
  PopupWindow.init()
