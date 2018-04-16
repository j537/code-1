export default class Utility {
  public static processResponse(): (response: Response) => Promise<any> {
    return (response: Response) => {
      if (response.ok) {
        // use catch to handle empty response body
        return response.json().catch(() => {});
      }

      return Promise.reject(new Error(response.statusText));
    };
  }
}
