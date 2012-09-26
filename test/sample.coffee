
Collection = require "../"

module.exports = ()->
  # This is probably something you would get back from a database
  friends = [
    id: "jdoe"
    fullName: "J. Doe"
    email: "jdoe@example.org"
  ,
    id: "msmith"
    fullName: "M. Smith"
    email: "msmith@example.org"
  ,
    id: "rwilliams"
    fullName: "R. Williams"
    email: "rwilliams@example.org"
  ]

  collection = Collection.create("/friends")
  # Links
  collection.addLink {href: "/friends/rss", rel: "feed"}

  # Items
  for friend in friends
    item = collection.addItem {href: "/friends/#{friend.id}"}
    item.addDatum {name: "fullName", value: friend.fullName}
    item.addDatum {name: "email", value: friend.email}
    item.addLink {href: "/blogs/#{friend.id}", rel: "blog", prompt: "Blog"}
    item.addLink {href: "/blogs/#{friend.id}/avatar", rel: "avatar", prompt: "Avatar", render: "image"}

  # Queries
  query = collection.addQuery {href: "/friends/search", rel: "search", prompt: "Search"}
  query.addDatum {name: "search"}
  
  # Template
  template = collection.getTemplate()
  template.addDatum {name: "fullName", prompt: "Full Name"}
  template.addDatum {name: "email", prompt: "Email"}
  template.addDatum {name: "blog", prompt: "Blog"}
  template.addDatum {name: "avatar", prompt: "Avatar"}
  collection
