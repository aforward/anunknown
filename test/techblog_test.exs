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
                 "<h1>\nSetting Up Your Blog</h1>\n<h2>\nApril 20, 2019</h2>\n<p>\nThis is your full-length article.</p>\n<p>\nTo display images that will display in github and\non your website, follow this pattern.</p>\n<p>\n  <img src=\"/assets/setting-up-blog/artboard.png\" alt=\"Art\" />\n</p>\n",
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
                 "<h1>\nSetting Up Your Blog</h1>\n<h2>\nApril 20, 2019</h2>\n<p>\nThis is your summary.</p>\n",
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
    assert "![My Image](/assets/blog/my-blog/a.png)" ==
             Techblog.format_images("![My Image](a.png?raw=true)", "blog", "my-blog")

    assert "This is a smple ![My Image](/assets/books/your-blog/a.png) substitution\n" ==
             Techblog.format_images(
               "This is a smple ![My Image](a.png?raw=true) substitution\n",
               "books",
               "your-blog"
             )

    assert "Leave me alone" == Techblog.format_images("Leave me alone", "my-blog")
  end

  test "format anchors with images" do
    markdown = """
    [![Highlights of Kent Beck's 'Beauty In Code'](https://img.youtube.com/vi/tM1iOJsR7p4/0.jpg)](https://www.youtube.com/watch?feature=player_embedded&v=tM1iOJsR7p4)
    """

    expected = """
    <p>\n<a href=\"https://www.youtube.com/watch?feature=player_embedded&v=tM1iOJsR7p4\">  <img src=\"https://img.youtube.com/vi/tM1iOJsR7p4/0.jpg\" alt=\"Highlights of Kent Beck&#39;s &#39;Beauty In Code&#39;\" />\n</a></p>
    """

    assert expected == Earmark.as_html!(markdown)
  end
end
