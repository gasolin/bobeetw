require_relative 'Plugin'
require 'date'

# Automatic Lunar Countdown Plugin for BoBee (baobi.tw / bobeetw)
# Pre-populated with exact 2026/2027 lunar dates for 初一/十五 and 初二/十六.
# Computes separate title and subtitle hierarchy for senior readability.
# Unifies subtitles under the warm mascot signature phrase enclosed in parenthesized format:
# '(保庇小蜂提醒您，...)' to match the visual system of all other link cards.
# Ensures perfect Chinese typography by removing all redundant spaces in Chinese text.
#
# Use in Liquid templates:
#   {{ vars.LunarCountdownPlugin.closer_15.title }}
#   {{ vars.LunarCountdownPlugin.closer_15.subtitle }}
class LunarCountdownPlugin < Plugin
  CHUYI_DATES = [
    "2026-02-17",
    "2026-03-19",
    "2026-04-17",
    "2026-05-17",
    "2026-06-15",
    "2026-07-15",
    "2026-08-13",
    "2026-09-12",
    "2026-10-11",
    "2026-11-10",
    "2026-12-09",
    "2027-01-08",
    "2027-02-06"
  ].map { |d| Date.parse(d) }.freeze

  SHIWU_DATES = [
    "2026-03-03",
    "2026-04-02",
    "2026-05-01",
    "2026-05-31",
    "2026-06-29",
    "2026-07-29",
    "2026-08-27",
    "2026-09-26",
    "2026-10-25",
    "2026-11-24",
    "2026-12-23",
    "2027-01-22",
    "2027-02-20"
  ].map { |d| Date.parse(d) }.freeze

  def execute
    today = Date.today

    # 1. Option A: 初一 / 十五 (Household Schedule)
    next_chuyi = CHUYI_DATES.find { |d| d >= today }
    next_shiwu = SHIWU_DATES.find { |d| d >= today }

    chuyi_delta = next_chuyi ? (next_chuyi - today).to_i : nil
    shiwu_delta = next_shiwu ? (next_shiwu - today).to_i : nil

    closer_15 = nil
    if chuyi_delta && shiwu_delta
      if chuyi_delta < shiwu_delta
        closer_15 = { "type" => "初一", "days" => chuyi_delta }
      else
        closer_15 = { "type" => "十五", "days" => shiwu_delta }
      end
    elsif chuyi_delta
      closer_15 = { "type" => "初一", "days" => chuyi_delta }
    elsif shiwu_delta
      closer_15 = { "type" => "十五", "days" => shiwu_delta }
    end

    # 2. Option B: 初二 / 十六 (Business Schedule)
    chuei_dates = CHUYI_DATES.map { |d| d + 1 }
    shiliu_dates = SHIWU_DATES.map { |d| d + 1 }

    next_chuei = chuei_dates.find { |d| d >= today }
    next_shiliu = shiliu_dates.find { |d| d >= today }

    chuei_delta = next_chuei ? (next_chuei - today).to_i : nil
    shiliu_delta = next_shiliu ? (next_shiliu - today).to_i : nil

    closer_16 = nil
    if chuei_delta && shiliu_delta
      if chuei_delta < shiliu_delta
        closer_16 = { "type" => "初二", "days" => chuei_delta }
      else
        closer_16 = { "type" => "十六", "days" => shiliu_delta }
      end
    elsif chuei_delta
      closer_16 = { "type" => "初二", "days" => chuei_delta }
    elsif shiliu_delta
      closer_16 = { "type" => "十六", "days" => shiliu_delta }
    end

    # Define high-contrast, two-level visual titles & subtitles
    # Enclosed in standard parentheses () to match the rest of the page links.
    # Chinese typography proofread: removed all redundant spaces between Chinese characters.
    title_15 = ""
    subtitle_15 = ""
    if closer_15
      if closer_15["days"] == 0
        title_15 = "今天就是農曆#{closer_15['type']}喔！"
        subtitle_15 = "(記得準備供品求平安喔！聲明：誠心最重要 🐝)"
      else
        title_15 = "下一個拜拜日：農曆#{closer_15['type']}"
        subtitle_15 = "(距離拜拜求平安還有 #{closer_15['days']} 天 🐝)"
      end
    end

    title_16 = ""
    subtitle_16 = ""
    if closer_16
      if closer_16["days"] == 0
        title_16 = "今天就是農曆#{closer_16['type']}喔！"
        subtitle_16 = "(記得做牙求財源、迎財神喔！🐝)"
      else
        title_16 = "下一個做牙日：農曆#{closer_16['type']}"
        subtitle_16 = "(距離做牙求財源還有 #{closer_16['days']} 天 🐝)"
      end
    end

    {
      "closer_15" => {
        "type" => closer_15&.dig("type"),
        "days" => closer_15&.dig("days"),
        "title" => title_15,
        "subtitle" => subtitle_15
      },
      "closer_16" => {
        "type" => closer_16&.dig("type"),
        "days" => closer_16&.dig("days"),
        "title" => title_16,
        "subtitle" => subtitle_16
      }
    }
  end
end
