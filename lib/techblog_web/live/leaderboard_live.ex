defmodule TechblogWeb.LeaderboardLive do
  use TechblogWeb, :live_view

  @clean_gender fn g ->
    case g do
      "" -> nil
      _ -> g
    end
  end

  @clean_integer fn s ->
    case s do
      "" -> nil
      0 -> nil
      _ -> String.to_integer(s)
    end
  end

  @clean_integers fn all_s ->
    all_s
    |> Enum.map(@clean_integer)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
    |> case do
      0 -> nil
      clean -> clean
    end
  end

  @clean_time fn
    "" ->
      nil

    "00:00" ->
      nil

    time ->
      time
      |> String.split(":")
      |> (fn [m, s] -> String.to_integer(m) * 60 + String.to_integer(s) end).()
  end

  @display_time fn time ->
    "#{time |> div(60) |> Integer.to_string() |> String.pad_leading(2, "0")}:#{time |> rem(60) |> Integer.to_string() |> String.pad_leading(2, "0")}"
  end

  @summary fn athletes ->
    athletes
    |> Enum.map(fn {name, %{scores: scores} = data} ->
      scores
      |> Enum.map(fn
        {_, {nil, _}} ->
          nil

        {:time, {time, time}} ->
          nil

        {:time, {time, _max_time}} ->
          @display_time.(time)

        {:reps, {reps, reps}} ->
          nil

        {:reps, {reps, _max_reps}} ->
          "#{reps} reps"
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.join(" ")
      |> case do
        "" -> "--"
        val -> val
      end
      |> (&{name, Map.put(data, :summary, &1)}).()
    end)
  end

  @sortable fn athletes ->
    athletes
    |> Enum.map(fn {name, %{mode: mode, scores: scores} = data} ->
      [{:mode, mode} | scores]
      |> Enum.map(fn
        {:mode, "rx"} ->
          2

        {:mode, "adaptive"} ->
          2

        {:mode, "scaled"} ->
          1

        {:mode, _} ->
          0

        {_, {nil, _}} ->
          nil

        {:time, {my_time, max_time}} ->
          max_time - my_time

        {:reps, {my_reps, _max_reps}} ->
          my_reps
      end)
      |> (fn sortable_score ->
            if Enum.any?(sortable_score, &is_nil/1) do
              0
            else
              sortable_score
            end
          end).()
      |> (&{name, Map.put(data, :sortable_score, &1)}).()
    end)
  end

  @sort fn scores ->
    scores
    |> Enum.sort_by(fn {_name, %{sortable_score: score}} -> score end)
    |> Enum.reverse()
  end

  @athletes [
              ["Alex Davis", "M", "18"],
              ["Amy Morin", "F", "18"],
              ["Andrew Forward", "M", "40"],
              ["Audrey Begin", "F", "18"],
              ["Billi Jane", "F", "40"],
              ["Brian Mumba", "M", "18"],
              ["Catherine Hovath", "F", "40"],
              ["Charles Cockerell", "F", "35"],
              ["Christian Holz", "M", "40"],
              ["Claude Mallet", "M", "55"],
              ["Dan Shrum", "M", "18"],
              ["Daniel Taggart", "M", "18"],
              ["David Van Gool", "M", "18"],
              ["Dee Kotsovos", "F", "55"],
              ["Dev Vasile", "F", "18"],
              ["Eleonor Buteau", "F", "18"],
              ["Elise Bonder", "F", "35"],
              ["Ethan Oliveira", "F", "18"],
              ["Everett Sloan", "M", "40"],
              ["Gabby Reid", "F", "18"],
              ["Gregory Ranger", "M", "18"],
              ["Guy Monette", "M", "55"],
              ["Hannah Cortes", "F", "18"],
              ["Heath Graham", "M", "45"],
              ["Honorata Zurakowski", "F", "35"],
              ["Jals Hal", "M", "18"],
              ["Kevin Deevey", "M", "55"],
              ["Kevin Lam", "M", "18"],
              ["Kevin Sourapha", "M", "18"],
              ["Keyvan Abedi", "M", "18"],
              ["Kirsten Brintnell", "F", "18"],
              ["Lauren Heuvel", "F", "18"],
              ["Livia Pellerin", "F", "40"],
              ["Louise Goodman", "F", "45"],
              ["Lyne Burton", "F", "50"],
              ["Mack Tommy", "M", "18"],
              ["Malcolm Savage", "M", "35"],
              ["Matthieu Desloges", "M", "18"],
              ["Maxime Grenier", "M", "18"],
              ["Meredith Rocchi", "F", "18"],
              ["Moses Abraham", "M", "45"],
              ["Natalie River", "F", "40"],
              ["Nick Loojimas", "M", "18"],
              ["Patrick Pickering", "M", "18"],
              ["Paul Robertson", "M", "60"],
              ["Peter Waisberg", "M", "50"],
              ["Rena Bivens", "F", "35"],
              ["Rob Frelich", "M", "45"],
              ["Roger Freedman", "M", "55"],
              ["Roni Garrard", "F", "18"],
              ["Samuel Cullen", "M", "18"],
              ["Shauna Fulton", "M", "18"],
              ["Sonya Leadbetter", "F", "45"],
              ["Stephanie Sloan", "F", "40"],
              ["Steve Carriere", "M", "18"],
              ["Taylor Stewart", "M", "18"],
              ["Tim Stephens", "M", "60"],
              ["Victor Baptista", "M", "18"],
              ["Rachel Dubenovski", "F", "18"],
              ["Grant McSheffrey", "M", "40"],
              ["Kristen Brintnell", "F", "18"],
              ["Kyle Kraglund", "M", "45"]
            ]
            |> Enum.map(fn [name, gender, age] ->
              {name, %{gender: @clean_gender.(gender), age_category: @clean_integer.(age)}}
            end)
            |> Enum.into(%{})

  @open201 [
             ["Andrew Forward", "rx", "15:00", "149"],
             ["Stephanie Sloan", "rx", "15:00", "114"],
             ["Moses Abraham", "scaled", "15:00", "128"],
             ["Keyvan Abedi", "rx", "15:00", "126"],
             ["Steve Carriere", "rx", "15:00", "165"],
             ["Meredith Rocchi", "", "00:00", ""],
             ["Tim Stephens", "rx", "15:00", "118"],
             ["Dan Shrum", "rx", "12:40", "180"],
             ["Brian Mumba", "", "00:00", ""],
             ["Rob Frelich", "scaled", "15:00", "106"],
             ["Lyne Burton", "scaled", "15:00", "126"],
             ["Dev Vasile", "", "00:00", ""],
             ["Christian Holz", "scaled", "15:00", "175"],
             ["Sonya Leadbetter", "", "00:00", ""],
             ["Patrick Pickering", "rx", "15:00", "126"],
             ["Gabby Reid", "rx", "15:00", "129"],
             ["Ethan Oliveira", "", "00:00", ""],
             ["Peter Waisberg", "rx", "15:00", "121"],
             ["Kevin Lam", "rx", "15:00", "161"],
             ["Roger Freedman", "rx", "15:00", "96"],
             ["David Van Gool", "scaled", "15:00", "158"],
             ["Amy Morin", "scaled", "15:00", "101"],
             ["Shauna Fulton", "rx", "15:00", "136"],
             ["Alex Davis", "scaled", "15:00", "124"],
             ["Catherine Hovath", "", "00:00", ""],
             ["Mack Tommy", "rx", "15:00", "175"],
             ["Daniel Taggart", "rx", "15:00", "127"],
             ["Eleonor Buteau", "rx", "15:00", "171"],
             ["Elise Bonder", "adaptive", "15:00", "156"],
             ["Louise Goodman", "rx", "15:00", "144"],
             ["Heath Graham", "rx", "15:00", "112"],
             ["Honorata Zurakowski", "rx", "15:00", "131"],
             ["Guy Monette", "rx", "15:00", "108"],
             ["Nick Loojimas", "rx", "15:00", "148"],
             ["Billi Jane", "", "00:00", ""],
             ["Paul Robertson", "", "00:00", ""],
             ["Livia Pellerin", "rx", "15:00", "129"],
             ["Audrey Begin", "rx", "13:51", "180"],
             ["Hannah Cortes", "", "00:00", ""],
             ["Kristen Brintnell", "rx", "15:00", "108"],
             ["Charles Cockerell", "rx", "15:00", "155"],
             ["Samuel Cullen", "rx", "15:00", "153"],
             ["Kevin Deevey", "rx", "15:00", "144"],
             ["Matthieu Desloges", "rx", "12:53", "180"],
             ["Roni Garrard", "rx", "15:00", "92"],
             ["Maxime Grenier", "rx", "15:00", "115"],
             ["Jals Hal", "", "00:00", ""],
             ["Lauren Heuvel", "rx", "14:42", "180"],
             ["Rena Bivens", "scaled", "15:00", "175"],
             ["Everett Sloan", "", "00:00", ""],
             ["Kevin Sourapha", "rx", "12:30", "180"],
             ["Victor Baptista", "rx", "15:00", "162"],
             ["Claude Mallet", "rx", "15:00", "158"],
             ["Gregory Ranger", "rx", "15:00", "143"],
             ["Natalie River", "rx", "15:00", "128"],
             ["Malcolm Savage", "rx", "15:00", "122"],
             ["Dee Kotsovos", "rx", "15:00", "74"],
             ["Taylor Stewart", "", "00:00", ""],
             ["Rachel Dubenovski", "adaptive", "00:00", ""],
             ["Grant McSheffrey", "rx", "15:00", "141"],
             ["Kyle Kraglund", "rx", "15:00", "126"]
           ]
           |> Enum.map(fn [name, mode, time, reps] ->
             {name,
              %{
                mode: mode,
                scores: [
                  {:time, {@clean_time.(time), 15 * 60}},
                  {:reps, {@clean_integer.(reps), 180}}
                ]
              }}
           end)
           |> @summary.()
           |> @sortable.()
           |> @sort.()

  @open202 [
             ["Andrew Forward", "rx", "513"],
             ["Stephanie Sloan", "scaled", "460"],
             ["Moses Abraham", "scaled", ""],
             ["Keyvan Abedi", "rx", "362"],
             ["Steve Carriere", "rx", "408"],
             ["Meredith Rocchi", "", ""],
             ["Tim Stephens", "rx", "136"],
             ["Dan Shrum", "rx", "784"],
             ["Brian Mumba", "", ""],
             ["Rob Frelich", "scaled", "476"],
             ["Lyne Burton", "scaled", "238"],
             ["Dev Vasile", "scaled", "582"],
             ["Christian Holz", "scaled", "893"],
             ["Sonya Leadbetter", "", ""],
             ["Patrick Pickering", "rx", "409"],
             ["Gabby Reid", "rx", "260"],
             ["Ethan Oliveira", "", ""],
             ["Peter Waisberg", "rx", "355"],
             ["Kevin Lam", "rx", ""],
             ["Roger Freedman", "rx", ""],
             ["David Van Gool", "scaled", "452"],
             ["Amy Morin", "scaled", ""],
             ["Shauna Fulton", "rx", ""],
             ["Alex Davis", "scaled", ""],
             ["Catherine Hovath", "scaled", ""],
             ["Mack Tommy", "scaled", "587"],
             ["Daniel Taggart", "rx", "280"],
             ["Eleonor Buteau", "rx", "578"],
             ["Elise Bonder", "adaptive", ""],
             ["Louise Goodman", "rx", "345"],
             ["Heath Graham", "rx", "239"],
             ["Honorata Zurakowski", "rx", "310"],
             ["Guy Monette", "scaled", "624"],
             ["Nick Loojimas", "rx", "416"],
             ["Billi Jane", "", ""],
             ["Paul Robertson", "", ""],
             ["Livia Pellerin", "rx", ""],
             ["Audrey Begin", "rx", "682"],
             ["Hannah Cortes", "", ""],
             ["Kristen Brintnell", "rx", ""],
             ["Charles Cockerell", "rx", "511"],
             ["Samuel Cullen", "rx", "485"],
             ["Kevin Deevey", "rx", "422"],
             ["Matthieu Desloges", "rx", "588"],
             ["Roni Garrard", "rx", ""],
             ["Maxime Grenier", "rx", "374"],
             ["Jals Hal", "", ""],
             ["Lauren Heuvel", "rx", "505"],
             ["Rena Bivens", "scaled", "714"],
             ["Everett Sloan", "rx", "448"],
             ["Kevin Sourapha", "rx", "609"],
             ["Victor Baptista", "rx", "374"],
             ["Claude Mallet", "rx", "204"],
             ["Gregory Ranger", "rx", "476"],
             ["Natalie River", "rx", ""],
             ["Malcolm Savage", "rx", "115"],
             ["Dee Kotsovos", "rx", ""],
             ["Taylor Stewart", "rx", "585"],
             ["Rachel Dubenovski", "adaptive", "450"],
             ["Grant McSheffrey", "rx", "306"],
             ["Kyle Kraglund", "rx", "306"]
           ]
           |> Enum.map(fn [name, mode, reps] ->
             {name,
              %{
                mode: mode,
                scores: [
                  {:reps, {@clean_integer.(reps), nil}}
                ]
              }}
           end)
           |> @summary.()
           |> @sortable.()
           |> @sort.()

  @open203 [
             ["Andrew Forward", "rx", "09:00", "90", "07:31"],
             ["Stephanie Sloan", "scaled", "09:00", "90", "09:00"],
             ["Moses Abraham", "scaled", "00:00", "", "00:00"],
             ["Keyvan Abedi", "", "00:00", "", "00:00"],
             ["Steve Carriere", "rx", "09:00", "90", "07:32"],
             ["Meredith Rocchi", "", "00:00", "", "00:00"],
             ["Tim Stephens", "", "00:00", "", "00:00"],
             ["Dan Shrum", "rx", "09:00", "131", "09:00"],
             ["Brian Mumba", "", "00:00", "", "00:00"],
             ["Rob Frelich", "scaled", "09:00", "112", "09:00"],
             ["Lyne Burton", "", "00:00", "", "00:00"],
             ["Dev Vasile", "", "00:00", "", "00:00"],
             ["Christian Holz", "scaled", "09:00", "138", "09:00"],
             ["Sonya Leadbetter", "", "00:00", "", "00:00"],
             ["Patrick Pickering", "", "00:00", "", "00:00"],
             ["Gabby Reid", "scaled", "07:22", "", "00:00"],
             ["Ethan Oliveira", "scaled", "09:00", "115", "09:00"],
             ["Peter Waisberg", "rx", "09:00", "84", "09:00"],
             ["Kevin Lam", "rx", "09:00", "86", "09:00"],
             ["Roger Freedman", "scaled", "09:00", "48", "09:00"],
             ["David Van Gool", "", "00:00", "", "00:00"],
             ["Amy Morin", "", "00:00", "", "00:00"],
             ["Shauna Fulton", "", "00:00", "", "00:00"],
             ["Alex Davis", "scaled", "00:00", "", "00:00"],
             ["Catherine Hovath", "scaled", "09:00", "100", "09:00"],
             ["Mack Tommy", "scaled", "09:00", "150", "09:00"],
             ["Daniel Taggart", "", "00:00", "", "00:00"],
             ["Eleonor Buteau", "rx", "09:00", "66", "09:00"],
             ["Elise Bonder", "adaptive", "09:00", "96", "09:00"],
             ["Louise Goodman", "scaled", "09:00", "97", "09:00"],
             ["Heath Graham", "scaled", "09:00", "112", "09:00"],
             ["Honorata Zurakowski", "scaled", "09:00", "121", "09:00"],
             ["Guy Monette", "scaled", "09:00", "137", "09:00"],
             ["Nick Loojimas", "rx", "09:00", "81", "09:00"],
             ["Billi Jane", "", "00:00", "", "00:00"],
             ["Paul Robertson", "", "00:00", "", "00:00"],
             ["Livia Pellerin", "", "00:00", "", "00:00"],
             ["Audrey Begin", "rx", "09:00", "83", "09:00"],
             ["Hannah Cortes", "scaled", "09:00", "165", "09:00"],
             ["Kristen Brintnell", "", "00:00", "", "00:00"],
             ["Charles Cockerell", "rx", "09:00", "94", "09:00"],
             ["Samuel Cullen", "", "00:00", "", "00:00"],
             ["Kevin Deevey", "rx", "09:00", "95", "09:00"],
             ["Matthieu Desloges", "rx", "09:00", "111", "09:00"],
             ["Roni Garrard", "", "00:00", "", "00:00"],
             ["Maxime Grenier", "", "00:00", "", "00:00"],
             ["Jals Hal", "rx", "09:00", "93", "09:00"],
             ["Lauren Heuvel", "", "00:00", "", "00:00"],
             ["Rena Bivens", "scaled", "09:00", "164", "09:00"],
             ["Everett Sloan", "rx", "09:00", "86", "09:00"],
             ["Kevin Sourapha", "rx", "09:00", "101", "09:00"],
             ["Victor Baptista", "rx", "09:00", "67", "09:00"],
             ["Claude Mallet", "rx", "09:00", "92", "09:00"],
             ["Gregory Ranger", "rx", "09:00", "84", "09:00"],
             ["Natalie River", "", "00:00", "", "00:00"],
             ["Malcom Savage", "rx", "09:00", "21", "09:00"],
             ["Dee Kotsovos", "", "00:00", "", "00:00"],
             ["Taylor Stewart", "rx", "09:00", "119", "09:00"],
             ["Rachel Dubenovski", "adaptive", "09:00", "111", "09:00"],
             ["Grant McSheffrey", "rx", "09:00", "25", "02:48"],
             ["Kyle Kraglund", "rx", "09:00", "21", "01:36"]
           ]
           |> Enum.map(fn [name, mode, time, reps, tiebreak] ->
             {name,
              %{
                mode: mode,
                scores: [
                  {:time, {@clean_time.(time), 9 * 60}},
                  {:reps, {@clean_integer.(reps), 165}},
                  {:time, {@clean_time.(tiebreak), 9 * 60}}
                ]
              }}
           end)
           |> @summary.()
           |> @sortable.()
           |> @sort.()

  @open204 [
             ["Andrew Forward", "rx", "20:00", "125", "11:30"],
             ["Stephanie Sloan", "rx", "20:00", "120", "20:00"],
             ["Moses Abraham", "rx", "20:00", "105", "20:00"],
             ["Keyvan Abedi", "", "00:00", "", "00:00"],
             ["Steve Carriere", "rx", "20:00", "160", "19:21"],
             ["Meredith Rocchi", "scaled", "20:00", "183", "20:00"],
             ["Tim Stephens", "rx", "20:00", "80", "20:00"],
             ["Dan Shrum", "rx", "20:00", "211", "15:12"],
             ["Brian Mumba", "rx", "20:00", "165", "13:59"],
             ["Rob Frelich", "scaled", "20:00", "165", "19:25"],
             ["Lyne Burton", "", "00:00", "", "00:00"],
             ["Dev Vasile", "", "00:00", "", "00:00"],
             ["Christian Holz", "scaled", "20:00", "173", "20:00"],
             ["Sonya Leadbetter", "", "00:00", "", "00:00"],
             ["Patrick Pickering", "", "00:00", "", "00:00"],
             ["Gabby Reid", "scaled", "20:00", "200", "20:00"],
             ["Ethan Oliveira", "scaled", "20:00", "162", "20:00"],
             ["Peter Waisberg", "rx", "20:00", "127", "12:56"],
             ["Kevin Lam", "", "00:00", "", "00:00"],
             ["Roger Freedman", "", "00:00", "", "00:00"],
             ["David Van Gool", "scaled", "20:00", "235", "20:00"],
             ["Amy Morin", "scaled", "20:00", "170", "15:45"],
             ["Shauna Fulton", "", "00:00", "", "00:00"],
             ["Alex Davis", "", "00:00", "", "00:00"],
             ["Catherine Hovath", "", "00:00", "", "00:00"],
             ["Mack Tommy", "rx", "20:00", "236", "20:00"],
             ["Daniel Taggart", "rx", "20:00", "136", "20:00"],
             ["Eleonor Buteau", "rx", "20:00", "200", "16:58"],
             ["Elise Bonder", "", "20:00", "169", "20:00"],
             ["Louise Goodman", "", "00:00", "", "00:00"],
             ["Heath Graham", "rx", "20:00", "120", "20:00"],
             ["Honorata Zurakowski", "scaled", "20:00", "200", "20:00"],
             ["Guy Monette", "scaled", "20:00", "199", "20:00"],
             ["Nick Loojimas", "", "00:00", "", "00:00"],
             ["Billi Jane", "", "00:00", "", "00:00"],
             ["Paul Robertson", "", "00:00", "", "00:00"],
             ["Livia Pellerin", "", "00:00", "", "00:00"],
             ["Audrey Begin", "rx", "20:00", "201", "16:35"],
             ["Hannah Cortes", "rx", "20:00", "130", "20:00"],
             ["Kristen Brintnell", "", "00:00", "", "00:00"],
             ["Charles Cockerell", "rx", "20:00", "166", "12:15"],
             ["Samuel Cullen", "rx", "20:00", "160", "11:00"],
             ["Kevin Deevey", "rx", "20:00", "164", "20:00"],
             ["Matthieu Desloges", "rx", "20:00", "169", "12:51"],
             ["Roni Garrard", "", "00:00", "", "00:00"],
             ["Maxime Grenier", "", "00:00", "", "00:00"],
             ["Jals Hal", "rx", "20:00", "160", "19:07"],
             ["Lauren Heuvel", "", "00:00", "", "00:00"],
             ["Rena Bivens", "", "00:00", "", "00:00"],
             ["Everett Sloan", "", "00:00", "", "00:00"],
             ["Kevin Sourapha", "rx", "20:00", "187", "20:00"],
             ["Victor Baptista", "rx", "20:00", "160", "15:16"],
             ["Claude Mallet", "", "00:00", "", "00:00"],
             ["Gregory Ranger", "rx", "20:00", "172", "20:00"],
             ["Natalie River", "", "00:00", "", "00:00"],
             ["Malcom Savage", "scaled", "20:00", "185", "13:35"],
             ["Dee Kotsovos", "", "00:00", "", "00:00"],
             ["Taylor Stewart", "rx", "20:00", "200", "19:17"],
             ["Rachel Dubenovski", "adaptive", "20:00", "135", "20:00"],
             ["Grant McSheffrey", "rx", "20:00", "120", "13:31"],
             ["Kyle Kraglund", "rx", "20:00", "120", "09:30"]
           ]
           |> Enum.map(fn [name, mode, time, reps, tiebreak] ->
             {name,
              %{
                mode: mode,
                scores: [
                  {:time, {@clean_time.(time), 20 * 60}},
                  {:reps, {@clean_integer.(reps), 240}},
                  {:time, {@clean_time.(tiebreak), 20 * 60}}
                ]
              }}
           end)
           |> @summary.()
           |> @sortable.()
           |> @sort.()

  @open205 [
             ["Andrew Forward", "rx", "20:00", "28", "80", "120", "19:43"],
             ["Stephanie Sloan", "", "00:00", "", "", "", "00:00"],
             ["Moses Abraham", "scaled", "17:14", "40", "80", "120", "20:00"],
             ["Keyvan Abedi", "", "00:00", "", "", "", "00:00"],
             ["Steve Carriere", "", "00:00", "", "", "", "00:00"],
             ["Meredith Rocchi", "scaled", "15:59", "40", "80", "120", "20:00"],
             ["Tim Stephens", "rx", "19:59", "40", "80", "120", "20:00"],
             ["Dan Shrum", "rx", "20:00", "34", "80", "120", "20:00"],
             ["Brian Mumba", "", "00:00", "", "", "", "00:00"],
             ["Rob Frelich", "scaled", "20:00", "10", "76", "120", "20:00"],
             ["Lyne Burton", "", "00:00", "", "", "", "00:00"],
             ["Dev Vasile", "", "00:00", "", "", "", "00:00"],
             ["Christian Holz", "scaled", "13:20", "40", "80", "120", "20:00"],
             ["Sonya Leadbetter", "", "00:00", "", "", "", "00:00"],
             ["Patrick Pickering", "", "00:00", "", "", "", "00:00"],
             ["Gabby Reid", "scaled", "17:04", "40", "80", "120", "20:00"],
             ["Ethan Oliveira", "scaled", "18:37", "40", "80", "120", "20:00"],
             ["Peter Waisberg", "rx", "20:00", "7", "80", "120", "20:00"],
             ["Kevin Lam", "", "00:00", "", "", "", "00:00"],
             ["Roger Freedman", "", "00:00", "", "", "", "00:00"],
             ["David Van Gool", "", "00:00", "", "", "", "00:00"],
             ["Amy Morin", "", "00:00", "", "", "", "00:00"],
             ["Shauna Fulton", "", "00:00", "", "", "", "00:00"],
             ["Alex Davis", "", "00:00", "", "", "", "00:00"],
             ["Catherine Hovath", "", "00:00", "", "", "", "00:00"],
             ["Mack Tommy", "scaled", "14:16", "40", "80", "120", "20:00"],
             ["Daniel Taggart", "", "00:00", "", "", "", "00:00"],
             ["Eleonor Buteau", "rx", "20:00", "8", "80", "120", "11:35"],
             ["Elise Bonder", "", "00:00", "", "", "", "00:00"],
             ["Louise Goodman", "", "00:00", "", "", "", "00:00"],
             ["Heath Graham", "rx", "20:00", "0", "80", "120", "14:22"],
             ["Honorata Zurakowski", "scaled", "20:00", "38", "80", "120", "20:00"],
             ["Guy Monette", "rx", "20:00", "0", "80", "120", "14:53"],
             ["Nick Loojimas", "rx", "00:00", "", "", "", "00:00"],
             ["Billi Jane", "", "00:00", "", "", "", "00:00"],
             ["Paul Robertson", "", "00:00", "", "", "", "00:00"],
             ["Livia Pellerin", "", "00:00", "", "", "", "00:00"],
             ["Audrey Begin", "rx", "20:00", "8", "80", "120", "11:08"],
             ["Hannah Cortes", "", "00:00", "", "", "", "00:00"],
             ["Kristen Brintnell", "", "00:00", "", "", "", "00:00"],
             ["Charles Cockerell", "rx", "20:00", "26", "80", "120", "14:19"],
             ["Samuel Cullen", "rx", "20:00", "18", "80", "120", "20:00"],
             ["Kevin Deevey", "rx", "19:53", "40", "80", "120", "20:00"],
             ["Matthieu Desloges", "rx", "16:40", "40", "80", "120", "20:00"],
             ["Roni Garrard", "", "00:00", "", "", "", "00:00"],
             ["Maxime Grenier", "", "00:00", "", "", "", "00:00"],
             ["Jals Hal", "", "00:00", "", "", "", "00:00"],
             ["Lauren Heuvel", "", "00:00", "", "", "", "00:00"],
             ["Rena Bivens", "scaled", "17:05", "40", "80", "120", "20:00"],
             ["Everett Sloan", "", "00:00", "", "", "", "00:00"],
             ["Kevin Sourapha", "", "00:00", "", "", "", "00:00"],
             ["Victor Baptista", "rx", "20:00", "16", "80", "120", "20:00"],
             ["Claude Mallet", "rx", "20:00", "31", "80", "120", "14:58"],
             ["Gregory Ranger", "rx", "20:00", "25", "80", "120", "19:12"],
             ["Natalie River", "", "00:00", "", "", "", "00:00"],
             ["Malcom Savage", "rx", "20:00", "0", "80", "120", "12:14"],
             ["Dee Kotsovos", "", "00:00", "", "", "", "00:00"],
             ["Taylor Stewart", "rx", "20:00", "32", "80", "120", "20:00"],
             ["Rachel Dubenovski", "", "00:00", "", "", "", "00:00"],
             ["Grant McSheffrey", "rx", "20:00", "0", "80", "120", "12:17"],
             ["Kyle Kraglund", "rx", "20:00", "0", "80", "120", "13:00"]
           ]
           |> Enum.map(fn [name, mode, time, mu_reps, cal_reps, wb_reps, tiebreak] ->
             {name,
              %{
                mode: mode,
                scores: [
                  {:time, {@clean_time.(time), 20 * 60}},
                  {:reps, {@clean_integers.([mu_reps, cal_reps, wb_reps]), 240}},
                  {:time, {@clean_time.(tiebreak), 20 * 60}}
                ]
              }}
           end)
           |> @summary.()
           |> @sortable.()
           |> @sort.()

  def render(assigns) do
    Phoenix.View.render(TechblogWeb.LeaderboardView, "index.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    socket
    |> assign_leaderboard(params)
    |> (&{:noreply, &1}).()
  end

  def mount(_params, _session, socket) do
    tick()

    {:ok,
     socket
     |> assign(tock: 1)
     |> assign_leaderboard(:open20x)}
  end

  def handle_event("sort_by", value, socket) do
    socket
    |> assign_leaderboard(value)
    |> (&{:noreply, push_patch(&1, to: leaderboard_url(&1))}).()
  end

  def handle_info(:tick, socket) do
    tick()
    {:noreply, socket |> update(:tock, &(&1 + 1))}
  end

  defp tick(), do: Process.send_after(self(), :tick, 1000)

  def position(athletes, scores) do
    scores
    |> Enum.filter(fn {name, _data} -> Map.get(athletes, name) end)
    |> position()
  end

  def position(scores) do
    scores
    |> Enum.reduce({0, 1, nil, []}, fn {name, %{sortable_score: sortable_score} = data},
                                       {last_p, ties, last_score, acc} ->
      {my_position, my_ties} =
        cond do
          last_score == sortable_score -> {last_p, ties + 1}
          true -> {last_p + ties, 1}
        end

      data
      |> Map.put(:position, my_position)
      |> (&{name, &1}).()
      |> (&[&1 | acc]).()
      |> (&{my_position, my_ties, sortable_score, &1}).()
    end)
    |> (fn {_, _, _, scores} -> scores end).()
  end

  defp workout_scores(athletes, scores) do
    athletes
    |> position(scores)
    |> Enum.into(%{})
  end

  def leaderboard(:all) do
    max_position = Enum.count(@athletes)

    open201 = workout_scores(@athletes, @open201)
    open202 = workout_scores(@athletes, @open202)
    open203 = workout_scores(@athletes, @open203)
    open204 = workout_scores(@athletes, @open204)
    open205 = workout_scores(@athletes, @open205)

    open20x =
      @athletes
      |> Enum.map(fn {name, _data} ->
        athlete_scores = [
          lookup_score(open201, name),
          lookup_score(open202, name),
          lookup_score(open203, name),
          lookup_score(open204, name),
          lookup_score(open205, name)
        ]

        score_overall =
          athlete_scores
          |> Enum.map(& &1.position)
          |> sum_scores(max_position)

        {name,
         %{
           mode: nil,
           time: nil,
           score: score_overall,
           sortable_score: max_position * Enum.count(athlete_scores) - score_overall,
           summary: "#{score_overall} points"
         }}
      end)
      |> Enum.sort_by(fn {_name, %{score: score}} -> score end)
      |> position()
      |> Enum.into(%{})

    @athletes
    |> Enum.map(fn {name, data} ->
      data
      |> Map.put(:open201, lookup_score(open201, name))
      |> Map.put(:open202, lookup_score(open202, name))
      |> Map.put(:open203, lookup_score(open203, name))
      |> Map.put(:open204, lookup_score(open204, name))
      |> Map.put(:open205, lookup_score(open205, name))
      |> Map.put(:open20x, lookup_score(open20x, name))
      |> (&{name, &1}).()
    end)
    |> Enum.into(%{})
  end

  defp sort_by(leaderboard, :name) do
    Enum.sort_by(leaderboard, fn {name1, _} -> name1 end)
  end

  defp sort_by(leaderboard, openRecord) do
    Enum.sort_by(leaderboard, fn {_, %{^openRecord => %{position: position}}} -> position end)
  end

  defp sum_scores(scores, max_position) do
    scores
    |> Enum.map(fn
      nil -> max_position
      real_score -> real_score
    end)
    |> Enum.sum()
  end

  defp lookup_score(scores, name) do
    Map.get(scores, name) ||
      %{
        position: nil,
        mode: nil,
        time: nil,
        score: nil,
        sortable_score: 0,
        summary: "--"
      }
  end

  defp assign_leaderboard(socket, raw_sort) do
    sort = sort_atom(raw_sort)
    leaderboard = socket.assigns[:leaderboard] || leaderboard(:all)

    socket
    |> assign_sort(sort)
    |> assign(:leaderboard, leaderboard |> sort_by(sort))
  end

  defp assign_sort(socket, sort) do
    selected_atom = String.to_atom("sort_#{sort}")

    socket
    |> assign(:sort, sort)
    |> assign(:sort_open20x, :off)
    |> assign(:sort_open201, :off)
    |> assign(:sort_open202, :off)
    |> assign(:sort_open203, :off)
    |> assign(:sort_open204, :off)
    |> assign(:sort_open205, :off)
    |> assign(selected_atom, :on)
  end

  defp sort_atom(%{"sort" => value}), do: sort_atom(value)
  defp sort_atom("20.1"), do: :open201
  defp sort_atom("20.2"), do: :open202
  defp sort_atom("20.3"), do: :open203
  defp sort_atom("20.4"), do: :open204
  defp sort_atom("20.5"), do: :open205
  defp sort_atom(_), do: :open20x

  defp leaderboard_url(socket) do
    sort_param =
      case socket.assigns[:sort] do
        :open201 -> "sort=20.1"
        :open202 -> "sort=20.2"
        :open203 -> "sort=20.3"
        :open204 -> "sort=20.4"
        :open205 -> "sort=20.5"
        _ -> nil
      end

    [sort_param]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("&")
    |> case do
      "" -> "/leaderboard"
      params -> "/leaderboard?#{params}"
    end
  end
end
