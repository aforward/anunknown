defmodule Techblog.BookTest do
  use ExUnit.Case
  alias Techblog.Book
  doctest Techblog.Book

  test "slugs (populated)" do
    assert %{
             "the-manual" => %{
               title: "The Manual: A Philosopher's Guide to Life Paperback",
               author: "Epictetus, Sam Torode",
               published: "May 11, 2017",
               sort: "2017-05-11",
               tags: ["basecamp", "seg4x05", "unread"],
               img: "/assets/books/the-manual/the-manual.png",
               body: "I love ponies.\n\n\n\nAnd cheese."
             }
           } == Book.slugs("test/fixtures/books")
  end
end
