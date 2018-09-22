//
//  ChatListViewModelBuilder.swift
//  MVVMChat
//
//  Created by Lucas van Dongen on 20/09/2018.
//  Copyright © 2018 Departamento B. All rights reserved.
//

import UIKit

class ChatListViewModelBuilder {
    class func build(for chats: [Chat]) -> ChatListViewModel {
        let chatListItemViewModels = chats.map(ChatListViewModelBuilder.build)
        let state: ChatListViewModel.State = chatListItemViewModels.isEmpty
            ? .empty : .loaded(chats: chatListItemViewModels)
        return ChatListViewModel(state: state, addChat: addChat)
    }

    class func buildLoading() -> ChatListViewModel {
        return ChatListViewModel(state: .loading, addChat: addChat)
    }

    class func build(for chat: Chat) -> ChatListItemViewModel {
        let lastMessageText = chat.messages.last?.message ?? ""
        let lastMessageDate = (chat.messages.last?.sendDate).map { DateRenderer.string(from: $0) } ?? ""
        let unreadMessageCount = ChatModelController.unreadMessages(for: chat.contact).count

        return ChatListItemViewModel(contact: chat.contact,
                                     message: lastMessageText,
                                     lastMessageDate: lastMessageDate,
                                     unreadMessageCount: unreadMessageCount) {
            let chatViewController = ChatViewController(for: chat)
            BaseNavigationViewController.pushViewController(chatViewController, animated: true)
        }
    }

    private class func addChat() {
        let createChatViewController = CreateChatViewController()
        BaseNavigationViewController.pushViewController(createChatViewController, animated: true)
    }
}
