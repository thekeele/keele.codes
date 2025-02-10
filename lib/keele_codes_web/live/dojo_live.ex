defmodule KeeleCodesWeb.DojoLive do
  use KeeleCodesWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex h-screen">
      <div class="flex flex-row max-md:flex-col md:my-auto max-md:mx-auto w-full justify-around items-center">
        <.profile_pic />
        <.code_links />
        <.career_links />
        <.contact_links />
      </div>
    </div>
    """
  end

  defp profile_pic(assigns) do
    ~H"""
    <a href="https://www.flickr.com/photos/supercoldskater/">
      <img class="w-36 h-36 rounded-xl" src={~p"/images/mark.jpeg"} />
    </a>
    """
  end

  defp code_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="https://github.com/thekeele" class="font-mono text-4xl text-sky-600 hover:text-sky-800">
        github
      </a>
      <a
        href="https://exercism.io/profiles/thekeele"
        class="font-mono text-4xl text-sky-600 hover:text-sky-800"
      >
        exercism
      </a>
    </div>
    """
  end

  defp career_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="https://keele.codes/resume" class="font-mono text-4xl text-sky-600 hover:text-sky-800">
        résumé
      </a>
      <a
        href="https://www.linkedin.com/in/thekeele"
        class="font-mono text-4xl text-sky-600 hover:text-sky-800"
      >
        linkedin
      </a>
    </div>
    """
  end

  defp contact_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="mailto:mark@keele.codes" class="font-mono text-lg text-white hover:text-gray-600">
        <.icon name="hero-envelope-solid" class="w-8 h-8 bg-white" /> mark@keele.codes
      </a>
      <div class="flex flex-row justify-between items-center">
        <a href="https://www.instagram.com/markiepooshreds/">
          <img class="w-8 h-5 rounded-sm" src={~p"/images/logo.png"} />
        </a>

        <p class="font-mono text-2xl dark:text-gray-600">made w/</p>

        <a href="https://keele.codes/bitcoin">
          <.icon name="hero-heart-solid" class="w-7 h-7 bg-red-600 hover:bg-orange-600" />
        </a>
      </div>
    </div>
    """
  end
end
