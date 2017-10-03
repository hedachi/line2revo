class AbstractSimulator
  @log_count = 0
  constructor: (plus, simulation_number) ->
    @plus = plus
    @simulation_number = simulation_number
  show_result: (result) ->
  show_message: (message) ->
    #$('.result_area').prepend "<div><div class='log_count'>#{++Simulator.log_count}</div>#{message}</div>"
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

class ScrollSimulator extends AbstractSimulator
  exec: (scroll_num) ->
    used_scroll_num = 0
    used_money = 0
    @show_message "スクロール#{scroll_num}枚で、武器+#{@plus}を強化します。"
    loop
      data = @constructor.get_data(@plus)
      used_scroll_num += data.scroll
      if scroll_num - used_scroll_num >= 0
        used_money += data.money
        before_plus = @plus
        is_success = (data.percent / 100) >= Math.random()
        if is_success
          result = '成功'
          @plus++
        else
          result = '失敗'
          unless @plus % 10 == 0 then @plus--
        @show_message "+#{before_plus}からスクロール#{data.scroll}枚、#{data.money}アデナ、成功率#{data.percent}%で強化...[#{result}]#{@plus}になりました。"
      else
        @show_message "スクロールが足りなくなりました。累計消費アデナ:#{used_money}"
        break

class TargetSimulator extends AbstractSimulator
  exec: (target_plus) ->
    used_scroll_num = 0
    used_money = 0
    result_process = [new Number(@plus)]
    loop
      data = @constructor.get_data(@plus)
      used_scroll_num += data.scroll
      if target_plus > @plus
        used_money += data.money
        before_plus = @plus
        is_success = (data.percent / 100) >= Math.random()
        if is_success
          @plus++
        else if @plus % 10 != 0
          @plus--
        result_process.push new Number(@plus)
        #console.log "+#{before_plus}からスクロール#{data.scroll}枚、#{data.money}アデナ、成功率#{data.percent}%で強化...[#{result}]#{@plus}になりました。"
      else
        $result_tr = $ '<tr></tr>'
        $result_tr.append $ "<td>#{@simulation_number}</td>"
        $result_tr.append $ "<td>#{result_process.length - 1}</td>"
        $result_tr.append $ "<td>#{used_scroll_num}</td>"
        $result_tr.append $("<td>#{result_process.map((plus)->" +#{plus} ").join('→')}</td>")
        $('table#result').append $result_tr
        break

with_scroll = false

$ ->
  execute = ->
      
    $('table#result > tr').not
    $('.result_area_header').not
    if with_scroll
      sim = new ScrollSimulator($('#plus').val())
      #sim.exec($('#scroll_num').val())
      sim.exec(Math.ceil(Math.random() * 100))
    else
      for i in [1...10]
        sim = new TargetSimulator($('#plus').val(), i)
        sim.exec($('#plus_target').val())
  for i in [0..30]
    $('#plus').append "<option value='#{i}'>#{i}</option>"
  for i in [1..30]
    $('#plus_target').append "<option value='#{i}'>#{i}</option>"
  $('#plus_target').append '<option value="">1</option>'
  $('#plus_target').val 5 + Math.ceil(Math.random() * 10)
  $('#run').click execute
  $('#plus').change ->
    if $('#plus_target').val() <= $('#plus').val()
      $('#plus_target').val(parseInt($('#plus').val()) + 1)
  execute()
  #s = new Simulator(8)
  #s.exec(40)

