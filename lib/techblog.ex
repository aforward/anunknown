defmodule Techblog do
  @moduledoc false
  @version Mix.Project.config()[:version]

  def formatted_version, do: "v" <> @version
end
