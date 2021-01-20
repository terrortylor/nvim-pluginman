describe('pluginman', function()
  describe('filesystem', function()
    local testModule
    local api

    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('pluginman.filesystem')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    before_each(function()
      api = mock(vim.api, true)
    end)

    after_each(function()
      mock.revert(api)
    end)

    describe("is_directory", function()
      it("Should return true when director exists", function()
        api.nvim_call_function.on_call_with("isdirectory", {"a/path"}).returns(1)

        local actual = testModule.is_directory("a/path")

        assert.equal(true, actual)
      end)

      it("Should return true when director exists", function()
        api.nvim_call_function.on_call_with("isdirectory", {"a/path"}).returns(0)

        local actual = testModule.is_directory("a/path")

        assert.equal(false, actual)
      end)
    end)
  end)
end)
