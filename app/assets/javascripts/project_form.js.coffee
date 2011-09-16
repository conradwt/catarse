$("#add_reward").click (e) ->
  e.preventDefault()
  new_reward = "<div class=\"reward\">" + $($(".reward")[0]).html() + "</div>"
  new_reward = new_reward.replace(/\_0\_/g, "_" + rewards_id + "_")
  new_reward = new_reward.replace(/\[0\]/g, "[" + rewards_id + "]")
  new_reward = $(new_reward)
  new_reward.find("input").val null
  new_reward.find("textarea").html null
  new_reward.find("input").numeric false
  new_reward.find("input, textarea").removeClass("ok").removeClass "error"
  $("#rewards_wrapper").append new_reward
  new_reward.find("textarea").focus()
  rewards_count++
  rewards_id++

video_valid = null
everything_ok = ->
  all_ok = true
  unless video_valid?
    all_ok = false
    verify_video()
  all_ok = false  unless ok("#project_name")
  all_ok = false  unless video_ok()
  all_ok = false  unless ok("#project_about")
  all_ok = false  unless headline_ok()
  all_ok = false  unless ok("#project_category_id")
  all_ok = false  unless goal_ok()
  all_ok = false  unless expires_at_ok()
  all_ok = false  unless rewards_ok()
  all_ok = false  unless accepted_terms()
  
  alert all_ok
  
  if all_ok
    $("#project_submit").attr "disabled", false
  else
    $("#project_submit").attr "disabled", true

ok = (id) ->
  value = $(id).val()
  if value and value.length > 0
    $(id).addClass("ok").removeClass "error"
    true
  else
    $(id).addClass("error").removeClass "ok"
    false

verify_video = ->
  video_valid = false
  if /http:\/\/(www\.)?vimeo.com\/(\d+)/.test($("#project_video_url").val())
    $("#project_video_url").removeClass("ok").removeClass("error").addClass "loading"
    $.get "/projects/vimeo/?url=" + $("#project_video_url").val(), (r) ->
      $("#project_video_url").removeClass "loading"
      if r.id == false
        video_valid = false
      else
        video_valid = true
      everything_ok()
  everything_ok()

video_ok = ->
  if video_valid
    $("#project_video_url").addClass("ok").removeClass "error"
    true
  else
    unless $("#project_video_url").hasClass("loading")
      $("#project_video_url").addClass("error").removeClass "ok"
      false

headline_ok = ->
  value = $("#project_headline").val()
  if value and value.length > 0 and value.length <= 140
    $("#project_headline").addClass("ok").removeClass "error"
    true
  else
    $("#project_headline").addClass("error").removeClass "ok"
    false

goal_ok = ->
  value = $("#project_goal").val()
  if /^(\d+)$/.test(value) and parseInt(value) > 0
    $("#project_goal").addClass("ok").removeClass "error"
    true
  else
    $("#project_goal").addClass("error").removeClass "ok"
    false

expires_at_ok = ->
  value = /^(\d{2})\/(\d{2})\/(\d{4})?$/.exec($("#project_expires_at").val())
  if value and value.length == 4
    year = parseFloat(value[3])
    month = parseFloat(value[2]) - 1
    day = parseFloat(value[1])
    date = new Date(year, month, day)
    current_date = new Date()
    if (day == date.getDate()) and (month == date.getMonth()) and (year == date.getFullYear()) and date > current_date
      $("#project_expires_at").addClass("ok").removeClass "error"
      true
    else
      $("#project_expires_at").addClass("error").removeClass "ok"
      false
  else
    $("#project_expires_at").addClass("error").removeClass "ok"
    false

rewards_ok = ->
  okey = true
  $(".reward input").each ->
    if /^(\d+)$/.test($(this).val())
      if /minimum_value/.test($(this).attr("id"))
        if parseInt($(this).val()) > 0
          $(this).addClass("ok").removeClass "error"
        else
          $(this).addClass("error").removeClass "ok"
          okey = false
      else
        $(this).addClass("ok").removeClass "error"
    else
      if /maximum_backers/.test($(this).attr("id")) and (not $(this).val())
        $(this).addClass("ok").removeClass "error"
      else
        $(this).addClass("error").removeClass "ok"
        okey = false
  
  $(".reward textarea").each ->
    if $(this).val() and $(this).val().length > 0
      $(this).addClass("ok").removeClass "error"
    else
      $(this).addClass("error").removeClass "ok"
      okey = false
  
  okey

accepted_terms = ->
  $("#accept").is ":checked"

$("#project_name").keyup everything_ok
$("#project_video_url").keyup ->
  video_valid = false
  everything_ok()

$("#project_video_url").timedKeyup verify_video
$("#project_about").keyup everything_ok
$("#project_category_id").change everything_ok
$("#project_goal").keyup everything_ok
$("#project_expires_at").keyup everything_ok
$("#project_headline").keyup everything_ok
$("#accept").click everything_ok
$(".reward input,.reward textarea").live "keyup", everything_ok
$("#project_goal").numeric false
$(".reward input").numeric false
$("#project_expires_at").datepicker 
  altFormat: "dd/mm/yy"
  onSelect: everything_ok

$("input,textarea,select").live "focus", ->
  $("p.inline-hints").hide()
  $(this).next("p.inline-hints").show()

$(".reward").live "mouseover", ->
  $(".remove_reward").hide()
  $(this).find(".remove_reward").show()  if rewards_count > 1

$(".reward").live "mouseout", ->
  $(this).find(".remove_reward").hide()

$(".remove_reward").live "click", (e) ->
  e.preventDefault()
  if rewards_count > 1
    reward = $(this).parentsUntil(".reward").parent()
    reward.remove()
    rewards_count--

$("#project_name").focus()
$("textarea").maxlength()
