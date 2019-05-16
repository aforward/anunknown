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
             "setting-up-blog" => %{title: "Setting Up Your Blog", sort: "20190420"}
           } == Techblog.slugs("test/fixtures/newinstall")
  end

  test "articles (new install)" do
    assert %{
             "setting-up-blog" => %{
               html:
                 "<h1>Setting Up Your Blog</h1>\n<h2>April 20, 2019</h2>\n<p>This is your full-length article.</p>\n",
               sort: "20190420",
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
               title: "Setting Up Your Blog"
             }
           } == "test/fixtures/newinstall" |> Techblog.summaries()
  end
end
