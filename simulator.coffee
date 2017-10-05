class AbstractSimulator
  constructor: (plus, simulation_number, try_times) ->
    @plus = plus
    @simulation_number = simulation_number
    @try_times = try_times
  show_result: (result) ->
  show_message: (message) ->
    $('.result_area').append "<div>#{message}</div>"
  @get_data = (plus) ->
    data = @DATA[plus]
    #console.log "get_data of +#{plus}"
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

class TargetSimulator extends AbstractSimulator
  @execute_count = 0
  @EXECUTE_COUNT_LIMIT = 100000
  exec: (target_plus) ->
    if TargetSimulator.execute_count > TargetSimulator.EXECUTE_COUNT_LIMIT
      alert "計算量が多すぎるため停止します。"
      throw "計算量が多すぎるため停止します。"
    @used_scroll_num = 0
    @used_money = 0
    @result_process = [new Number(@plus)]
    loop
      TargetSimulator.execute_count++
      if target_plus > @plus
        data = @constructor.get_data(@plus)
        @used_scroll_num += data.scroll
        @used_money += data.money
        before_plus = @plus
        is_success = (data.percent / 100) >= Math.random()
        if is_success
          @plus++
        else if @plus == 30 || @plus % 10 != 0
          @plus--
        @result_process.push new Number(@plus)
        #console.log "+#{before_plus}からスクロール#{data.scroll}枚、#{data.money}アデナ、成功率#{data.percent}%で強化...[#{result}]#{@plus}になりました。"
      else
        @show_result()
        break
  show_result: ->
    $result_tr = $ '<tr></tr>'
    $result_tr.append $ "<td>#{@simulation_number}</td>"
    $result_tr.append $ "<td class='enhance_times'>#{@result_process.length - 1}</td>"
    $result_tr.append $ "<td class='used_scroll_num'>#{@used_scroll_num}</td>"
    $result_tr.append $ "<td class='used_money'>#{@used_money}</td>"
    $result_tr.append $ "<td class='used_money_not_weapon'>#{Math.round @used_money/4}</td>"
    if Controller.show_details()
      text = @result_process.map((plus)->" +#{plus} ").join('→')
      $result_tr.append $("<td><input class='show_details' type='button' value='詳細' data-details='#{text}'/></td>")
    $('table#result').append $result_tr

with_scroll = false

class Controller
  @get_sum = (selector) ->
    sum = 0
    $(selector).each (index, element) ->
      sum += parseInt element.innerHTML
    sum
  @get_average = (selector) ->
    average = @get_sum(selector) / $(selector).size()
    Math.round(average * 10) / 10
  @initialize = ->
    $('span.result_plus').text $('#plus').val()
    $('span.result_plus_target').text $('#plus_target').val()
    $('span.result_execute_times').text parseInt($('#simulation_type').val())
    TargetSimulator.execute_count = 0
    $('table#result tr').not('#result_area_header').detach()
  @finalize = ->
    $('#average_enhance_times').text @get_average('.enhance_times').toFixed(1)
    $('#average_used_scroll_num').text @get_average('.used_scroll_num').toFixed(1)
    used_money_average = @get_average('.used_money')
    $('#average_used_money').text (used_money_average / 10000).toFixed(1)
    $('#average_used_money_not_weapon').text (used_money_average / 4 / 10000).toFixed(1)
    #$result_tr = $ '<tr></tr>'
    #$result_tr.append $ "<td>平均</td>"
    #$result_tr.append $ "<td class='enhance_times'>#{@get_average('.enhance_times')}</td>"
    #$result_tr.append $ "<td class='used_scroll_num'>#{@get_average('.used_scroll_num')}</td>"
    #used_money_average = @get_average('.used_money')
    #$result_tr.append $ "<td class='used_money'>#{used_money_average}</td>"
    #$result_tr.append $ "<td class='used_money_not_weapon'>#{used_money_average / 4}</td>"
    #$('tr#result_area_header').after $result_tr
  @execute = ->
    @initialize()
    if with_scroll
      sim = new ScrollSimulator($('#plus').val())
      #sim.exec($('#scroll_num').val())
      sim.exec(Math.ceil(Math.random() * 100))
    else
      try_times = parseInt $('#simulation_type').val()
      $('th#result_details').toggle(@show_details())
      for i in [1...try_times]
        sim = new TargetSimulator($('#plus').val(), i, try_times)
        sim.exec(parseInt $('#plus_target').val())
      @finalize()
  @show_details = ->
    #parseInt $('#simulation_type').val() <= 10
    false

$ ->
  for i in [0..29]
    $('#plus').append "<option value='#{i}'>#{i}</option>"
  for i in [1..30]
    $('#plus_target').append "<option value='#{i}'>#{i}</option>"

  $('#plus').val 5 + Math.floor(Math.random() * 5)
  $('#plus_target').val parseInt($('#plus').val()) + 1

  $('#run').click -> Controller.execute()
  $('#plus').change ->
    $('#plus_target').val(parseInt($('#plus').val()) + 1)
    Controller.execute()
  $('#plus_target').change -> Controller.execute()
  $('#simulation_type').change -> Controller.execute()
  Controller.execute()
  $('#close_popup_window').click -> $('#popup_window').hide()
