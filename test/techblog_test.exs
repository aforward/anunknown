defmodule TechblogTest do
  use ExUnit.Case
  doctest Techblog

  test "slugs (populated)" do
    assert %{
             "one" => %{title: "My First Title", sort: "b"},
             "two" => %{title: "My Real Second Title", sort: "a"}
           } == Techblog.slugs("test/fixtures/populated")
  end

  test "slugs (new install)" do
    assert %{
             "setting-up-blog" => %{
               title: "Setting Up Your Blog",
               sort: "20190420",
               tags: ["elixir", "erlang"]
             }
           } == Techblog.slugs("test/fixtures/newinstall")
  end

  test "articles (new install)" do
    assert %{
             "setting-up-blog" => %{
               html:
                 "<h1>Setting Up Your Blog</h1>\n<h2>April 20, 2019</h2>\n<p>This is your full-length article.</p>\n<p>To display images that will display in github and\non your website, follow this pattern.</p>\n<p><img src=\"/images/artboard.png\" alt=\"Art\" /></p>\n",
               sort: "20190420",
               tags: ["elixir", "erlang"],
               title: "Setting Up Your Blog"
             }
           } == "test/fixtures/newinstall" |> Techblog.articles()
  end

  test "summaries (new install)" do
    assert %{
             "setting-up-blog" => %{
               html:
                 "<h1>Setting Up Your Blog</h1>\n<h2>April 20, 2019</h2>\n<p>This is your summary.</p>\n",
               sort: "20190420",
               tags: ["elixir", "erlang"],
               title: "Setting Up Your Blog"
             }
           } == "test/fixtures/newinstall" |> Techblog.summaries()
  end

  test "tags" do
    assert %{"elixir" => 1, "erlang" => 1} == "test/fixtures/newinstall" |> Techblog.tags()
  end

  test "format_images looks for ?raw=true in an image block" do
    assert "![My Image](/images/a.png)" ==
             Techblog.format_images("![My Image](/assets/static/images/a.png?raw=true)")

    assert "/assets/static/images/a.png?raw=true" ==
             Techblog.format_images("/assets/static/images/a.png?raw=true")

    assert "This is a smple ![My Image](/images/a.png) substitution\n" ==
             Techblog.format_images(
               "This is a smple ![My Image](/assets/static/images/a.png?raw=true) substitution\n"
             )

    assert "Leave me alone" == Techblog.format_images("Leave me alone")
  end
end
