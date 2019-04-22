defmodule TechblogTest do
  use ExUnit.Case
  doctest Techblog

  test "slugs (populated)" do
    assert %{
             "one" => %{title: "My First Title"},
             "two" => %{title: "My Second Title"}
           } == Techblog.slugs("test/fixtures/populated")
  end

  test "slugs (new install)" do
    assert %{
             "setting-up-blog" => %{title: "Setting Up Your Blog"}
           } == Techblog.slugs("test/fixtures/newinstall")
  end

  test "articles (new install)" do
    assert %{
             "setting-up-blog" =>
               "<h1>Setting Up Your Blog</h1>\n<h2>April 20, 2019</h2>\n<p>This is your full-length article.</p>\n"
           } == "test/fixtures/newinstall" |> Techblog.articles()
  end

  test "summaries (new install)" do
    assert %{
             "setting-up-blog" =>
               "<h1>Setting Up Your Blog</h1>\n<h2>April 20, 2019</h2>\n<p>This is your summary.</p>\n"
           } == "test/fixtures/newinstall" |> Techblog.summaries()
  end
end
