defmodule Mix.Tasks.Sugar.Gen.ModelTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  Application.put_env(:sugar, Mix.Tasks.Sugar.Gen.ModelTest.Repos.Main, [])

  test "run_detached/1" do
    assigns = [
      app: :test_app,
      module: "Mix.Tasks.Sugar.Gen.ModelTest",
      path: "test/fixtures"
    ]
    capture_io(fn ->
      Mix.Tasks.Sugar.Gen.Model.run_detached(assigns ++ [name: "main"])
    end)

    assert File.exists?("test/fixtures/models/main.ex") === true
    assert File.exists?("test/fixtures/queries/main.ex") === true
    cleanup
  end

  test "run/1 with proper name" do
    args = ["main", "--path=test/fixtures", "--module=Mix.Tasks.Sugar.Gen.ModelTest"]
    capture_io(fn ->
      Mix.Tasks.Sugar.Gen.Model.run(args)
    end)

    assert File.exists?("test/fixtures/models/main.ex") === true
    assert File.exists?("test/fixtures/queries/main.ex") === true
    cleanup
  end

  test "run/1 with no name" do
    args = ["--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Gen.Model.run(args)
    end
  end

  test "run/1 with improper name" do
    args = ["main/bad", "--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Gen.Model.run(args)
    end
  end

  defp cleanup do
    File.rm_rf! "test/fixtures/models"
    File.rm_rf! "test/fixtures/queries"
    File.rm_rf! "test/fixtures/repo"
  end

  defmodule Repos.Main do
    use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env, otp_app: :sugar
  end
end
