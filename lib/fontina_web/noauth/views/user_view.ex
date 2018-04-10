# TODO: Get rid of this code duplication. Will probably require refactoring Fontina a little
# (The Auth/NoAuth separation the way I'm doing it is dumb in the first place...)
defmodule FontinaWeb.NoAuth.UserView do
  use FontinaWeb, :view
  import Phoenix.HTML.Form
end
