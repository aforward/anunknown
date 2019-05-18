# Phoenix LiveView Examples
### May 18, 2019

[LiveView](https://github.com/phoenixframework/phoenix_live_view)
for [Phoenix](https://github.com/phoenixframework/phoenix) on [Elixir](https://github.com/elixir-lang/elixir) is definitely scratching an itch
in the world of rich client apps, without having to go full-on
client-side framework.  Here's a list of open
source projects, some with online demos and other where you can
(easily) run the code locally.

Sometimes it's best to learn by examples, here goes.

| Screenshot | Description | References |
| -- | ---| -- |
| ![Ant Farm](/images/liveview-examples/phoenix_liveview_ant_farm.png) | A virtual ant farm where every ant was a GenServer process, simulating a basic AI behavior. Originally straightforward, it got much bigger and eventually forgotten. Finally gave the ant farm another go, this time using Elixir only. So I rolled up my sleeves, and surprisingly, four or five hours later I had the ant farm working, and this is how it was done... | [Concurrent ant farm with Elixir and Phoenix LiveView](http://codeloveandboards.com/blog/2019/03/28/concurrent-ant-farm-with-elixir-and-phoenix-liveview/) <br> [Ant Farm Demo](https://phoenix-liveview-ant-farm.herokuapp.com/) <br> [Ant Farm Source](https://github.com/bigardone/phoenix-liveview-ant-farm) |
| ![Erlang Observer](/images/liveview-examples/phoenix_liveview_observer.png) | A port of [observer_cli](https://github.com/zhongwencool/observer_cli) using [LiveView](https://github.com/phoenixframework/phoenix_live_view). The docs are clear, accurate and provide a very smooth introduction to the capabilities of this interactive server-side rendering way of doing things. | [Observer Live](https://zorbash.com/post/observer-live/) <br> [Erlang Observer Demo](https://liveview.zorbash.com/) <br> [Erlang Observer Source](https://github.com/zorbash/observer_live) |
| ![Markdown Editor](/images/liveview-examples/phoenix_liveview_markdown.png) | When a client connects to the server they are initially served some HTML content. In our case, what is initially rendered is a textarea prepopulated with some Markdown and the HTML view of that Markdown. However, this is where things get interesting. A websocket connection is opened between the client and the server. The server listens for changes in the textbox, re-renders the HTML, and sends the smallest possible change back to the client which then updates the DOM. | [Markdown Editor Demo](http://markdown.dichev.io/) <br> [Markdown Editor Source](https://github.com/nickdichev/markdown-live) |
| ![Flappy Bird](/images/liveview-examples/phoenix_liveview_flappy_bird.png) | Flappy Bird Clone written in LiveView.  Some interesting files: [Live "view"](https://github.com/moomerman/flappy-phoenix/blob/master/lib/flappy_phoenix_web/live/game_live.ex), [game logic](https://github.com/moomerman/flappy-phoenix/blob/master/lib/flappy_phoenix/game.ex), [UI (leex)](https://github.com/moomerman/flappy-phoenix/blob/master/lib/flappy_phoenix_web/templates/game/index.html.leex) | [Flappy Bird Demo](https://flappy-phoenix.herokuapp.com/) <br> [Flappy Bird Source](https://github.com/moomerman/flappy-phoenix) |
| ![Breakout](/images/liveview-examples/phoenix_liveview_breakout.png) | A Breakout clone written in pure Elixir, using Phoenix LiveView. | [Breakout Demo](https://breakoutex.tommasopifferi.com/) <br> [Breakout Source](https://github.com/neslinesli93/breakoutex) |
| ![Black Jack](/images/liveview-examples/phoenix_liveview_blackjack.png) | A Black Jack game | [Black Jack Source](https://github.com/dorilla/live_view_black_jack) |
| ![Hippo](/images/liveview-examples/phoenix_liveview_hippo.png) | Hippopotamuses have been the subjects of various African folktales. According to a San story; when the Creator assigned each animal its place in nature, the hippos wanted to live in the water, but were refused out of fear that they might eat all the fish. After begging and pleading, the hippos were finally allowed to live in the water on the conditions that they would eat grass instead of fish and would fling their dung so that it can be inspected for fish bones. | [Hippo Demo](https://elegant-monstrous-planthopper.gigalixirapp.com/) <br> [Hippo Source](https://github.com/miladamilli/hippo_game_live/) |
| ![Bear Game](/images/liveview-examples/phoenix_liveview_bear.png) | A little toy repo to show off a very unnecessarily fast-rendering clock, done with Phoenix LiveView. There's also a keyboard demo in here, just haven't had a chance to write it up yet, but it does have a super cute bear 🐻. | [Bear Game Demo](http://palegoldenrod-grown-ibis.gigalixirapp.com/bear_game) <br> [Bear Game Source](https://github.com/aleph-naught2tog/live_tinkering) |
| ![Bear Necessities](/images/liveview-examples/phoenix_liveview_bear_necessities.png) | Another game involving a bear. | [Bear Necessities Demo](https://unbearable.nl/) <br> [Bear Necessities Source](https://github.com/DefactoSoftware/BearNecessities) |
| ![Milwaukee Property Search](/images/liveview-examples/phoenix_liveview_property_search.png) | A website that allows filtering by some attributes from Milwaukee's [Master Property Record](http://city.milwaukee.gov/DownloadTabularData3496.htm?docid=3496) | [Milwaukee Property Search Demo](https://mprop.mitchellhenke.com/) <br> [Milwaukee Property Search Source](https://github.com/mitchellhenke/mprop) |
| ![Falling Tiles](/images/liveview-examples/phoenix_liveview_falling_tiles.png) | Simple shares, rotate the fast-dropping puzzle pieces and create solid lines — which then disappear. Rince and Repeat. | [Falling Tiles Demo](https://falling-tiles.angelika.me/) <br> [Falling Tiles Source](https://github.com/angelikatyborska/falling_blocks) |
| ![Wikipedia LiveView](/images/liveview-examples/phoenix_liveview_wikipedia.png) | Wikipedia LiveView, a little demo to test out some phoenix_live_view features using the SSE provided from the [wikimedia Kafka clusters](https://wikitech.wikimedia.org/wiki/Event_Platform/EventStreams). | [Wikipedia LiveView Source](https://github.com/fklement/wikipedia_live_view) |
| ![Undo](/images/liveview-examples/phoenix_liveview_undo.png) | A simple pattern for support an undo feature. | [Undo Source](https://github.com/joerichsen/phoenix_live_view_example/blob/undo_example/lib/demo_web/live/undo_live.ex) |
| ![Logic Simulator](/images/liveview-examples/phoenix_liveview_logic_simulator.png) | Simulating Logic Gates Switches and Lightbulbs. | [Logic Simulator Source](https://github.com/TheFirstAvenger/logic_sim_liveview) |
| ![Doom's Fire](/images/liveview-examples/phoenix_liveview_dooms_fire.png) | DOOM fire animated from server side. Made with [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view). Based on [Doom fire algorithm](https://github.com/filipedeschamps/doom-fire-algorithm) | [Doom's Fire Demo](https://elixir-doom-fire.herokuapp.com/) <br> [Doom's Fire Source](https://github.com/allmonty/elixir-live-doom-fire) |
| ![SVG Editor](/images/liveview-examples/phoenix_liveview_svgeditor.png) | SVG Editor | [Source](https://github.com/mmmries/showoff) |
| ![Calculator](/images/liveview-examples/phoenix_liveview_calculator.png) | A simple calculator written in LiveView. | [Calculator Source](https://github.com/smeade/phoenix_live_view_example/blob/master/lib/demo_web/live/calc_live/index.ex) |
| ![Pixels with Frenemies](/images/liveview-examples/phoenix_liveview_pixels_with_frenemies.png) | Simple app to see how easy it would be to expand the demo apps to real-time collaboration. Spoiler: it was easy, in 1 day. Now just select a color and paint the canvas! | [Pixels with Frenemies Demo](https://stormy-earth-96381.herokuapp.com/collaborative_canvas) <br> [Pixels with Frenemies Source](https://github.com/JohnB/phoenix_live_view_example) |
| ![Load Generator](/images/liveview-examples/phoenix_liveview_load_generator.png) | Synthetic load generator + ad-hoc scheduler observer powered by LiveView | [Load Generator Source](https://github.com/sasa1977/demo_system/tree/replace-js-with-live-view) |
| ![Sea Battle](/images/liveview-examples/phoenix_liveview_sea_battle.png) | Sea Battle game (require "registration") | [Sea Battle Demo](https://radiant-plateau-73240.herokuapp.com/) <br> [Sea Battle Source](https://github.com/Sanchos01/Phoenix-Sea-Battle) |
| ![Bluetooth Low Energy Heart Rate Sensor](/images/liveview-examples/phoenix_liveview_bluetooth_low_energy_heart_rate_senor.png) | Bluetooth Low Energy Heart Rate Sensor that gets [Bluetooth Low Energy's](https://www.w3.org/community/web-bluetooth/) heart rate sensor data, and presents the results using LiveView. | [Bluetooth Low Energy Heart Rate Sensor Source](https://github.com/khamada611/ble_live_sample) |
| ![Bike Comapare](/images/liveview-examples/phoenix_liveview_bike_compare.png) | Bike Comparison tool written in LiveView | [Bike Source](https://gist.github.com/andrielfn/6bbf0bf7fa644bfad304752bfae081f9) |
| ![Adventure Capitalist](/images/liveview-examples/phoenix_liveview_adventure_capitalist.png) | A very simple implementation of [Adventure Capitalist](https://en.wikipedia.org/wiki/AdVenture_Capitalist) | [Adventure Capitalist Source](https://github.com/eteubert/open_adventure_capitalist) |
| ![Phoenix Live Examples](/images/liveview-examples/phoenix_liveview_examples.png) | A collection of examples including: thermostat, snake, autocomplete search, image editor, clock, pacman, rainbow, counter, "top", CRUD (users), presence | [Phoenix Live Examples Source](https://github.com/chrismccord/phoenix_live_view_example) |
| ![Table Sort](/images/liveview-examples/phoenix_liveview_tablesort.png) | Table Sort in LiveView | [Phoenix Table Sort Source](https://github.com/joerichsen/phoenix_live_view_example/blob/table_example/lib/demo_web/live/table_live.ex) |
| ![Elixir Match](/images/liveview-examples/phoenix_liveview_match.png) | Elixir Match is an online version of the memory card game. | [Elixir Match Source](https://github.com/toranb/elixir-match) |
| ![Empex Display](/images/liveview-examples/phoenix_liveview_empexdisplay.png) | Manipulating a SVG graphic for the 2019 [Empex NY conference](https://empex.co/nyc.html) | [Empex SVG Demo](/demo/empex) <br> [Empex SVG Source](https://github.com/empex2019liveview/empexlogo) |
| ![Hangman](/images/liveview-examples/phoenix_liveview_hangman.png) | Impleneting a LiveView UI for Dave Thomas' DIET implementation of hangman [Empex NY conference](https://empex.co/nyc.html) | [Hangman Demo](/demo/hangman) <br> [Hangman Source](https://github.com/empex2019liveview/hangman) |
| ![Towers of Hanoi](/images/liveview-examples/phoenix_liveview_hanoi.png) | Impleneting a LiveView UI for the Towers of Hanoi game.s | [Towers of Hanoi Demo](/demo/hanoi) <br> [Towers of Hanoi Source](https://github.com/empex2019liveview/hanoi) |

## Articles

Below are a variety of articles on LiveView from mange perspectives.s

* [Walk-Through of Phoenix LiveView](https://elixirschool.com/blog/phoenix-live-view/)
* [Swapping React for Phoenix LiveView](https://medium.com/qixxit-development/swapping-react-for-phoenix-liveview-db6581f27a14)
* [A Story of Phoenix LiveView: Writing a CRUD Application](https://itnext.io/a-story-of-phoenix-liveview-writing-a-crud-application-d938e52894d4)
* [Elixir Phoenix LiveView with a real world example](http://jypepin.com/elixir-phoenix-liveview-with-a-real-world-example)
* [Real World Phoenix |> A LiveView Dashboard](https://www.theguild.nl/real-world-phoenix-of-groter-dan-a-liveview-dashboard/)
* [Phoenix LiveView Impressions](https://haughtcodeworks.com/blog/software-development/elixir-phoenix-liveview/)
* [Phoenix LiveView: Interactive, Real-Time Apps. No Need to Write JavaScript](https://dockyard.com/blog/2018/12/12/phoenix-liveview-interactive-real-time-apps-no-need-to-write-javascript)


## Videos

#### Chris McCord Keynote: ElixirConf 2018 (LiveView Sneak Peak)

<a href="https://www.youtube.com/watch?feature=player_embedded&v=Z2DU0qLfPIY" target="_blank" style="text-align: left"><img src="/images/liveview-examples/video_elixirconf_2018_chrismccord.png" alt="Chris McCord Keynote: ElixirConf 2018 (LiveView Sneak Peak)" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### Chris McCord Keynote: ElixirConf EU 2019 (LiveView Released)

<a href="https://www.youtube.com/watch?feature=player_embedded&v=8xJzHq8ru0M" target="_blank"><img src="/images/liveview-examples/video_elixirconfeu_2019_chrismccord.png" alt="Chris McCord Keynote: Code Sync 2019 (LiveView Released)" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### How to Create a Counter with Phoenix LiveView

<a href="https://dennisbeatty.com/2019/03/19/how-to-create-a-counter-with-phoenix-live-view.html" target="_blank"><img src="http://img.youtube.com/vi/2bipVjOcvdI/0.jpg" alt="How to Create a Counter with Phoenix LiveView" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### How to Create a Todo List with Phoenix LiveView

<a href="https://dennisbeatty.com/2019/04/24/how-to-create-a-todo-list-with-phoenix-liveview.html" target="_blank"><img src="http://img.youtube.com/vi/qpaFivCmJOY/0.jpg" alt="How to Create a Todo List with Phoenix LiveView" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### Integrating Phoenix LiveView

<a href="https://blog.smartlogic.io/integrating-phoenix-liveview/" target="_blank"><img src="http://img.youtube.com/vi/FfpRBh2kWCI/0.jpg" alt="Integrating Phoenix LiveView" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### Live Coding LiveView w/ Bruce Tate

<a href="https://www.youtube.com/watch?feature=player_embedded&v=-wzabRyc-0M" target="_blank"><img src="http://img.youtube.com/vi/-wzabRyc-0M/0.jpg" alt="Live Coding LiveView w/ Bruce Tate" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

#### Getting Started With Phoenix LiveView 3 Parts (Elixircasts)

<a href="https://elixircasts.io/phoenix-liveview-part-1" target="_blank"><img src="/images/liveview-examples/video_elixircasts_part1.png" alt="Getting Started With Phoenix LiveView Part 1 (Free)" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

<a href="https://elixircasts.io/phoenix-liveview-part-2" target="_blank"><img src="/images/liveview-examples/video_elixircasts_part2.png" alt="Getting Started With Phoenix LiveView Part 2 (Free)" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

<a href="https://elixircasts.io/phoenix-liveview-part-3" target="_blank"><img src="/images/liveview-examples/video_elixircasts_part3.png" alt="Getting Started With Phoenix LiveView Part 3 (Subscription)" width="500px" style="margin-left: 0" height="auto" border="0" /></a>

## Audios

* [Elixir Talk - Episode 141 - More LiveView Stuff and Desmond Wants to Work With You](https://soundcloud.com/elixirtalk/episode-141-more-liveview-stuff-and-desmond-wants-to-work-with-you)


## Other Curated Lists

List of Lists is fun.  Here are a few other places where LiveView lists are being maintained.

| Name | URL |
| --- | --- |
| [Tefter](https://tefter.io) | [Phoenix LiveView Examples](https://tefter.io/zorbash/lists/phoenix-liveview-examples) |
| [Leandro Cesquini Pereira](https://medium.com/@leandrocesquini) | [Phoenix Liveview Collection](https://medium.com/@leandrocesquini/phoenix-liveview-collection-8259f35ff2b0) |

