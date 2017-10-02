class Simulator
  @log_count = 0
  constructor: (plus) ->
    @plus = plus
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

$ ->
  for i in [0..30]
    $('#plus').append "<option value='#{i}'>#{i}</option>"
  for i in [1..30]
    $('#plus_target').append "<option value='#{i}'>#{i}</option>"
  $('#plus_target').append '<option value="">1</option>'
  $('#run').click ->
    sim = new Simulator($('#plus').val())
    #sim.exec($('#scroll_num').val())
    sim.exec(Math.ceil(Math.random() * 100))
  $('#plus').change ->
    if $('#plus_target').val() <= $('#plus').val()
      $('#plus_target').val(parseInt($('#plus').val()) + 1)
  #s = new Simulator(8)
  #s.exec(40)

