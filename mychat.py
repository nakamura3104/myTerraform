import openai
import os
import sys

def chat_with_gpt(prompt):
    openai.api_key = os.environ.get("OPENAI_API_KEY")  # Make sure to set the environment variable
    model_engine = "text-davinci-002"  # Replace this with the appropriate model name

    response = openai.Completion.create(
        engine=model_engine,
        prompt=prompt,
        max_tokens=100,
        n=1,
        stop=None,
        temperature=0.8,
    )

    message = response.choices[0].text.strip()
    return message

def interactive_chat():
    print("Starting interactive chat with GPT-4. Type 'exit' to end the conversation.")
    
    while True:
        prompt = input("You: ")
        
        if prompt.lower() == 'exit':
            print("Ending the conversation.")
            break

        response = chat_with_gpt(prompt)
        print("GPT-4:", response)

if __name__ == "__main__":
    interactive_chat()
