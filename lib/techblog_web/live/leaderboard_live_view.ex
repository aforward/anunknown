defmodule TechblogWeb.LeaderboardLiveView do
  use Phoenix.LiveView

  @clean_gender fn g ->
    case g do
      "" -> nil
      _ -> g
    end
  end

  @clean_integer fn s ->
    case s do
      "" -> nil
      _ -> String.to_integer(s)
    end
  end

  @clean_time fn t ->
    case t do
      "" -> nil
      "00:00" -> nil
      _ -> t
    end
  end

  @cleanable fn data ->
    data
    |> Enum.map(fn
      [name, mode, time, score] ->
        [name, mode, @clean_time.(time), @clean_integer.(score)]

      [name, mode, score] ->
        [name, mode, @clean_integer.(score)]
    end)
  end

  @sortable fn data, max ->
    data
    |> Enum.map(fn
      [_name, mode, score] = record ->
        p1 =
          case mode do
            "rx" -> "200"
            "adaptive" -> "200"
            "scaled" -> "100"
            _ -> "000"
          end

        p2 = String.pad_leading("#{score}", 5, "0")
        sortable_score = "#{p1}#{p2}" |> String.to_integer()
        [sortable_score | record]

      [_name, mode, time, score] = record ->
        sortable_score =
          case [time, score] do
            [nil, _] ->
              0

            [_, nil] ->
              0

            _ ->
              p1 =
                case mode do
                  "rx" -> "200"
                  "adaptive" -> "200"
                  "scaled" -> "100"
                  _ -> "000"
                end

              p2 = String.pad_leading("#{score}", 3, "0")

              p3 =
                time
                |> String.split(":")
                |> (fn [m, s] ->
                      in_seconds = String.to_integer(m) * 60 + String.to_integer(s)
                      "#{max - in_seconds}"
                    end).()
                |> String.pad_leading(4, "0")

              "#{p1}#{p2}#{p3}" |> String.to_integer()
          end

        [sortable_score | record]
    end)
  end

  @sort fn scores ->
    Enum.sort(scores, fn [sortable1 | _], [sortable2 | _] ->
      sortable1 > sortable2
    end)
  end

  @summary fn scores, max_time, max_score ->
    scores
    |> Enum.map(fn
      [sortable_score, name, mode, score] ->
        summary =
          case score do
            nil -> "--"
            _ -> "#{score} reps"
          end

        {name,
         %{
           mode: mode,
           time: max_time,
           score: score,
           sortable_score: sortable_score,
           summary: summary
         }}

      [sortable_score, name, mode, time, score] ->
        summary =
          case [time, score] do
            [_, nil] -> "--"
            [^max_time, _] -> "#{score} reps"
            [_, ^max_score] -> "#{time}"
            _ -> "--"
          end

        {name,
         %{
           mode: mode,
           time: time,
           score: score,
           sortable_score: sortable_score,
           summary: summary
         }}
    end)
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
              ["Danial Taggart", "M", "18"],
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
              ["Kevin Deevey", "M", "50"],
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
              ["Taylor Steward", "M", "18"],
              ["Tim Stephens", "M", "55"],
              ["Victor Baptista", "M", "18"],
              ["Rachel Dubenovski", "", ""]
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
             ["Malcom Savage", "rx", "15:00", "122"],
             ["Dee Kotsovos", "rx", "15:00", "74"],
             ["Taylor Steward", "", "00:00", ""],
             ["Rachel Dube", "adaptive", "00:00", ""]
           ]
           |> @cleanable.()
           |> @sortable.(15 * 60)
           |> @sort.()
           |> @summary.("15:00", 180)

  @open202 [
             ["Andrew Forward", "rx", "513"],
             ["Stephanie Sloan", "scaled", ""],
             ["Moses Abraham", "scaled", "460"],
             ["Keyvan Abedi", "rx", "362"],
             ["Steve Carriere", "rx", "408"],
             ["Meredith Rocchi", "", ""],
             ["Tim Stephens", "rx", "136"],
             ["Dan Shrum", "rx", "784"],
             ["Brian Mumba", "", ""],
             ["Rob Frelich", "scaled", "476"],
             ["Lyne Burton", "scaled", "238"],
             ["Dev Vasile", "scaled", "582"],
             ["Christian Holz", "scaled", "1301"],
             ["Sonya Leadbetter", "", ""],
             ["Patrick Pickering", "rx", "409"],
             ["Gabby Reid", "rx", "260"],
             ["Ethan Oliveira", "", ""],
             ["Peter Waisberg", "rx", ""],
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
             ["Audrey Begin", "rx", ""],
             ["Hannah Cortes", "", ""],
             ["Kristen Brintnell", "rx", ""],
             ["Charles Cockerell", "rx", ""],
             ["Samuel Cullen", "rx", "485"],
             ["Kevin Deevey", "rx", "422"],
             ["Matthieu Desloges", "rx", "588"],
             ["Roni Garrard", "rx", ""],
             ["Maxime Grenier", "rx", ""],
             ["Jals Hal", "", ""],
             ["Lauren Heuvel", "rx", "505"],
             ["Rena Bivens", "scaled", ""],
             ["Everett Sloan", "rx", "448"],
             ["Kevin Sourapha", "rx", "609"],
             ["Victor Baptista", "rx", ""],
             ["Claude Mallet", "rx", ""],
             ["Gregory Ranger", "rx", "476"],
             ["Natalie River", "rx", ""],
             ["Malcom Savage", "scaled", "698"],
             ["Dee Kotsovos", "rx", ""],
             ["Taylor Steward", "rx", "585"],
             ["Rachel Dube", "adaptive", ""]
           ]
           |> @cleanable.()
           |> @sortable.(nil)
           |> @sort.()
           |> @summary.("20:00", nil)

  def render(assigns) do
    TechblogWeb.LeaderboardView.render("index.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    socket
    |> assign_leaderboard(params)
    |> (&{:noreply, &1}).()
  end

  def mount(_session, socket) do
    # if connected?(socket), do: tick()
    {:ok,
     socket
     |> assign(tock: 1)
     |> assign_leaderboard(:open20x)}
  end

  def handle_event("sort_by", value, socket) do
    socket
    |> assign_leaderboard(value)
    |> (&{:noreply, &1}).()
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

  def leaderboard(:all) do
    max_position = Enum.count(@athletes)

    open201 =
      @athletes
      |> position(@open201)
      |> Enum.into(%{})

    open202 =
      @athletes
      |> position(@open202)
      |> Enum.into(%{})

    open20x =
      @athletes
      |> Enum.map(fn {name, _data} ->
        score201 = lookup_score(open201, name)
        score202 = lookup_score(open202, name)
        score_overall = sum_scores([score201.position, score202.position], max_position)
        sortable_score = max_position * 2 - score_overall

        {name,
         %{
           mode: nil,
           time: nil,
           score: score_overall,
           sortable_score: sortable_score,
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
    |> assign(:sort, sort)
    |> assign(:leaderboard, leaderboard |> sort_by(sort))
  end

  defp sort_atom(%{"sort" => value}), do: sort_atom(value)
  defp sort_atom("20.1"), do: :open201
  defp sort_atom("20.2"), do: :open202
  defp sort_atom(_), do: :open20x
end
