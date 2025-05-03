return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    --build = "make tiktoken", -- Only on MacOS or Linux
    init = function()
      local getIcon = require("core.assets").getIcon
      vim.keymap.set("n", "<leader>C", "", { desc = getIcon("ui", "Copilot", 1) .. "CopilotChat" })
      vim.keymap.set("n", "<leader>Co", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat Toggle" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>Cp", "<cmd>CopilotChatPrompt<cr>", { desc = "CopilotChat Prompt" })
      vim.keymap.set("n", "<leader>Cm", "<cmd>CopilotChatModels<cr>", { desc = "CopilotChat Models" })
      vim.keymap.set("n", "<leader>Ca", "<cmd>CopilotChatAgents<cr>", { desc = "CopilotChat Agents" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>Cc", "<cmd>CopilotChatCommit<cr>", { desc = "CopilotChat Commit" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>Cd", "<cmd>CopilotChatDocs<cr>", { desc = "CopilotChat Docs" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>Cf", "<cmd>CopilotChatFix<cr>", { desc = "CopilotChat Fix" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>Ce", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat Explain" })
      vim.keymap.set({ "n", "v", "x" }, "<leader>CO", "<cmd>CopilotChatOptimize<cr>", { desc = "CopilotChat Optimize" })
    end,
    opts = {
      model = "gpt-4o", -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
      window = {
        layout = "horizontal", -- horizontal, vertical, or floating
        width = 1,
        height = 0.3,
        row = 40,
        zindex = 1,
      },

      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
