using ChatAppWithDBExample.ChatApp.Model;
using ChatAppWithDBExample.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ChatAppWithDBExample.ChatApp.DAL.UserRepository
{
    public class UserRepository
    {
        ChatAppDBEntities _Context;

        public UserRepository()
        {
            _Context = new ChatAppDBEntities();
        }



        public bool Login(LoginData loginData, out int userId)
        {
            userId = 0;
            var currentUser = _Context.Users.Where(x => x.Email == loginData.Email).FirstOrDefault();
            if (currentUser != null)
            {
                userId = currentUser.UserId;
                return true;
            }
            return false;
        }

        public List<UserDTO> GetUsersToChat()
        {
            var userId = int.Parse(HttpContext.Current.User.Identity.Name);
            return _Context.Users
                .Include("UserConnections")
                .Where(x => x.UserId != userId)
                .Select(x => new UserDTO
                {
                    UserId = x.UserId,
                    FirstName = x.FirstName,
                    //FullName = x.FullName,
                    IsOnline = x.UserConnections.Count > 0,
                }).ToList();
        }

        internal int AddUserConnection(Guid ConnectionId)
        {
            var userId = int.Parse(HttpContext.Current.User.Identity.Name);
            _Context.UserConnections.Add(new UserConnection
            {
                ConnectionId = ConnectionId,
                UserId = userId,
            });
            _Context.SaveChanges();
            return userId;
        }

        internal int RemoveUserConnection(Guid ConnectionId)
        {
            int userId = 0;
            var current = _Context.UserConnections.FirstOrDefault(x => x.ConnectionId == ConnectionId);
            if (current != null)
            {
                userId = current.UserId ?? 0;
                _Context.UserConnections.Remove(current);
                _Context.SaveChanges();
            }
            return userId;
        }

        internal IList<string> GetUSerConnections(int uSerId)
        {
            return _Context.UserConnections.Where(x => x.UserId == uSerId).Select(x => x.ConnectionId.ToString()).ToList();
        }

        internal void RemoveAllUserConnections(int userId)
        {
            var current = _Context.UserConnections.Where(x => x.UserId == userId);
            _Context.UserConnections.RemoveRange(current);
            _Context.SaveChanges();
        }

        public ChatBoxModel GetChatbox(int toUserId)
        {
            var userId = int.Parse(HttpContext.Current.User.Identity.Name);
            var toUser = _Context.Users.FirstOrDefault(x => x.UserId == toUserId);
            var messages = _Context.Messages.Where(x => (x.FromUser == userId && x.ToUser == toUserId) || (x.FromUser == toUserId && x.ToUser == userId))
                .OrderByDescending(x => x.Date)
                //.ToList();
                .Skip(0)
                .Take(50)
                .Select(x => new MessageDTO
                {
                    FromUser = x.FromUser,
                    ToUser =x.ToUser,
                    ID = x.Id,
                    Message = x.Message1,
                    Class = x.FromUser == userId ? "from" : "to",
                })
                .OrderBy(x => x.ID)
                .ToList();

            //var ToUser = ToUserDTO(toUser);
            //var da = ToUser;
            
            return new ChatBoxModel
            {
                ToUser = ToUserDTO(toUser),
                Messages = messages,
            };
        }

        internal bool SendMessage(int toUserId, string message)
        {
            try
            {
                int USER_ID = int.Parse(HttpContext.Current.User.Identity.Name);
                _Context.Messages.Add(new Message
                {
                    FromUser = USER_ID,
                    ToUser = toUserId,
                    Message1 = message,
                    Date = DateTime.Now
                });
                _Context.SaveChanges();
                ChatHub.RecieveMessage(USER_ID, toUserId, message);
                return true;
            }
            catch { return false; }
        }

        public int DeleteMessage(int messageId)
        {
            try
            {
                var messageData = _Context.Messages.Where(x => x.Id == messageId).FirstOrDefault();
                int fUser =Convert.ToInt32(messageData.ToUser);
                _Context.Messages.Remove(messageData);
                _Context.SaveChanges();
                return fUser;
            }
            catch { return 0; }
        }

        public int DeleteMessageFromYou(int messageId, int userId, int fromUser, int toUser)
        {
            try
            {
                var messageData = _Context.Messages.Where(x => x.Id == messageId).FirstOrDefault();
                int fUser = Convert.ToInt32(messageData.FromUser);
                int tUser = Convert.ToInt32(messageData.FromUser);

                if (messageData.FromUser== userId)
                {
                    
                    messageData.FromUser = null;
                    _Context.SaveChanges();
                    return fUser;
                }
                else
                {
                    messageData.ToUser = null;
                    _Context.SaveChanges();
                    return fUser;
                }
            }
            catch { return 0; }
        }

        public UserDTO ToUserDTO(User user)
        {
            return new UserDTO
            {
                FirstName = user.FirstName,
                UserId = user.UserId,
                
                //UserName = user.Username,
            };
        }


        internal List<MessageDTO> LazyLoadMssages(int toUserId, int skip)
        {
            var userId = int.Parse(HttpContext.Current.User.Identity.Name);
            var messages = _Context.Messages.Where(x => (x.FromUser == userId && x.ToUser == toUserId) || (x.FromUser == toUserId && x.ToUser == userId))
                .OrderByDescending(x => x.Date)
                .Skip(skip)
                .Take(50)
                .Select(x => new MessageDTO
                {
                    //FromUser = Convert.ToInt32(x.FromUser),
                    //ToUser = Convert.ToInt32(x.ToUser),
                    ID = x.Id,
                    Message = x.Message1,
                    Class = x.FromUser == userId ? "from" : "to",
                })
                .OrderByDescending(x => x.ID)
                .ToList();
            return messages;
        }

        internal bool ExistingUser(User userData)
        {
            User user = new User();
            var existUser = _Context.Users.Where(x => x.Email == userData.Email).FirstOrDefault();

            if (existUser == null)
            {
                user.FirstName = userData.FirstName;
                user.LastName = userData.LastName;
                user.Email = userData.Email;

                _Context.Users.Add(user);
                _Context.SaveChanges();

                return true;
            }
            return false;
        }
    }
}